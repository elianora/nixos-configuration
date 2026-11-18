{ config, lib, pkgs, ... }:

let
  mk-thread-string = type: builtins.concatStringsSep "," (map (thread: toString thread) config.software.virtualization.kvm.vfio-passthrough.cpu-threads.${type});
  all-threads = mk-thread-string "all";
  host-threads = mk-thread-string "host";
  vm-threads = builtins.concatStringsSep "," (map (thread-info: toString thread-info.cpuset) config.software.virtualization.kvm.vfio-passthrough.cpu-threads.vm);
in
{
  options.custom-packages.vfio-scripts = lib.mkOption {
    description = "VFIO Scripts for QEMU Hooks";
    type = with lib.types; attrsOf package;
  };

  config.custom-packages.vfio-scripts = {
    hooks-common = pkgs.writeScript "hooks-common.sh" ''
      ## PCI Devices
      VIRSH_GPU_IDENTIFIER=${config.software.virtualization.kvm.vfio-passthrough.pci-identifiers.gpu}
      VIRSH_GPU_AUDIO_IDENTIFIER=${config.software.virtualization.kvm.vfio-passthrough.pci-identifiers.gpu-audio}
      VIRSH_HD_AUDIO_IDENTIFIER=${config.software.virtualization.kvm.vfio-passthrough.pci-identifiers.hd-audio}

      ## Memory for hugepages
      MEMORY_ASSIGNED_TO_VM_IN_MiB=${toString config.software.virtualization.kvm.vfio-passthrough.vm-memory}

      ## CPU isolation settings
      ALL_CPU_THREADS=${all-threads}
      HOST_CPU_THREADS=${host-threads}
      VM_CPU_THREADS=${vm-threads}
      VFIO_UNDO_FILE=/var/run/libvirt/qemu/vfio-isolate-undo.bin
    '';

    alloc-hugepages = pkgs.writeShellScriptBin "alloc-hugepages.sh" ''
      set -eux

      ## Load common configuration
      source /var/lib/libvirt/hooks/hooks-common.sh

      ## Allocate hugepages
      HUGEPAGE_SIZE=$(($MEMORY_ASSIGNED_TO_VM_IN_MiB/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/awk '{print $2}')/1024))))
      echo $HUGEPAGE_SIZE > /proc/sys/vm/nr_hugepages
      ALLOCATED_HUGEPAGE_SIZE=$(cat /proc/sys/vm/nr_hugepages)
      COUNT=0
      while (( $ALLOCATED_HUGEPAGE_SIZE != $HUGEPAGE_SIZE && $COUNT < 1000 )); do
        echo 1 > /proc/sys/vm/compact_memory
        echo $HUGEPAGE_SIZE > /proc/sys/vm/nr_hugepages
        ALLOCATED_HUGEPAGE_SIZE=$(cat /proc/sys/vm/nr_hugepages)
        echo "Allocated hugepage size: ''${ALLOCATED_HUGEPAGE_SIZE}"
        echo "Target hugepage size: ''${HUGEPAGE_SIZE}"
        let COUNT+=1
      done

      if [ "''${ALLOCATED_HUGEPAGE_SIZE}" -ne "''${HUGEPAGE_SIZE}" ]; then
        echo "Was unable to allocate hugepages, exiting..."
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
      fi
    '';

    dealloc-hugepages = pkgs.writeShellScriptBin "dealloc-hugepages.sh" ''
      set -eux

      ## Load common configuration
      source /var/lib/libvirt/hooks/hooks-common.sh

      ## Reset hugepage value
      echo 0 > /proc/sys/vm/nr_hugepages
    '';

    isolate-cpus = pkgs.writeShellScriptBin "isolate-cpus.sh" ''
      set -eux

      ## Load common configuration
      source /var/lib/libvirt/hooks/hooks-common.sh

      ## Ensure cpuset is added to subtree_control
      echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control

      ## Isolate CPUs
      ${config.custom-packages.vfio-isolate}/bin/vfio-isolate \
        -u $VFIO_UNDO_FILE \
        drop-caches \
        cpu-governor performance C$HOST_CPU_THREADS \
        cpuset-modify --cpus C$HOST_CPU_THREADS /system.slice \
        cpuset-modify --cpus C$HOST_CPU_THREADS /user.slice  \
        move-tasks / /system.slice \
        compact-memory \
        irq-affinity mask C$VM_CPU_THREADS

      ${pkgs.util-linux}/bin/taskset -pc $HOST_CPU_THREADS 2
    '';

    revert-cpu-isolation = pkgs.writeShellScriptBin "revert-cpu-isolation.sh" ''
      set -eux

      ## Load common configuration
      source /var/lib/libvirt/hooks/hooks-common.sh

      ## Ensure cpuset is added to subtree_control
      echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control

      ## Disable CPU isolation
      ${config.custom-packages.vfio-isolate}/bin/vfio-isolate restore $VFIO_UNDO_FILE
      ${pkgs.util-linux}/bin/taskset -pc $ALL_CPU_THREADS 2
    '';

    revert = pkgs.writeShellScriptBin "revert.sh" ''
      set -eux

      ## Load common configuration
      source /var/lib/libvirt/hooks/hooks-common.sh

      ## Unload VFIO
      modprobe -r vfio_iommu_type1
      modprobe -r vfio_pci
      modprobe -r vfio

      ## Have virsh re-bind the GPU
      ${pkgs.libvirt}/bin/virsh nodedev-reattach $VIRSH_GPU_IDENTIFIER
      ${pkgs.libvirt}/bin/virsh nodedev-reattach $VIRSH_GPU_AUDIO_IDENTIFIER
      ${pkgs.libvirt}/bin/virsh nodedev-reattach $VIRSH_HD_AUDIO_IDENTIFIER

      ## Re-bind consoles
      echo 1 > /sys/class/vtconsole/vtcon0/bind
      echo 0 > /sys/class/vtconsole/vtcon1/bind

      ## Avoid dependency issues
      sleep 5

      ## Unload NVIDIA drivers
      modprobe nvidia_drm
      modprobe nvidia_modeset
      modprobe nvidia_uvm
      modprobe nvidia

      ## Start Plasma
      systemctl start display-manager
    '';

    start = pkgs.writeShellScriptBin "start.sh" ''
      set -eux

      ## Load common configuration
      source /var/lib/libvirt/hooks/hooks-common.sh

      ## Stop Plasma
      systemctl stop display-manager

      ## Unbind consoles and framebuffer
      echo 0 > /sys/class/vtconsole/vtcon0/bind
      echo 0 > /sys/class/vtconsole/vtcon1/bind

      ## Avoid dependency issues
      sleep 5

      ## Unload NVIDIA drivers
      modprobe -r nvidia_drm
      modprobe -r nvidia_modeset
      modprobe -r nvidia_uvm
      modprobe -r nvidia

      ## Have virsh unbind the GPU
      ${pkgs.libvirt}/bin/virsh nodedev-detach $VIRSH_GPU_IDENTIFIER
      ${pkgs.libvirt}/bin/virsh nodedev-detach $VIRSH_GPU_AUDIO_IDENTIFIER
      ${pkgs.libvirt}/bin/virsh nodedev-detach $VIRSH_HD_AUDIO_IDENTIFIER

      ## Load VFIO
      modprobe vfio
      modprobe vfio_pci
      modprobe vfio_iommu_type1
    '';
  };
}
