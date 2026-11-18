{ config, lib, pkgs, ... }:

let
  any-user-has-desktop-environments-enabled = builtins.any (user: config.home-manager.users.${user}.software.desktop-environments.plasma.enable) (builtins.attrNames config.home-manager.users);
  irq-affinity-threads = builtins.concatStringsSep "," (map (thread: toString thread) config.software.virtualization.kvm.vfio-passthrough.cpu-threads.emulator);
in
{
  imports = [
    ./vfio-isolate.nix
    ./vfio-scripts.nix
    ./vfio-tools.nix
    ./virtual-machines
  ];

  options.software.virtualization.kvm = {
    enable = lib.mkEnableOption "Enables QEMU KVM on this machine";
    vfio-passthrough = {
      enable = lib.mkEnableOption "Enables VFIO passthrough on this machine";
      cpu-threads = {
        all = lib.mkOption {
          description = "The full range of all CPU threads available on the CPU";
          type = with lib.types; listOf int;
        };

        emulator = lib.mkOption {
          description = "The threads to pin the emulator that handles interrupt requests and non-blocking processes";
          type = with lib.types; listOf int;
        };

        host = lib.mkOption {
          description = "The host CPU threads to isolate";
          type = with lib.types; listOf int;
        };

        io = lib.mkOption {
          description = "The threads to pin for IO";
          type = with lib.types; listOf int;
        };

        vm = lib.mkOption {
          description = "The VM CPU threads to isolate";
          type = with lib.types; listOf (submodule ({ ... }: {
            options = {
              vcpu = lib.mkOption {
                description = "The vCPU to assign the thread to";
                type = lib.types.int;
              };

              cpuset = lib.mkOption {
                description = "The CPU thread to assign to the vCPU";
                type = lib.types.int;
              };
            };
          }));
        };
      };

      pci-identifiers = {
        gpu = lib.mkOption {
          description = "The QEMU KVM identifier for the passthrough GPU";
          type = lib.types.str;
        };

        gpu-audio = lib.mkOption {
          description = "The QEMU KVM identifier for the passthrough GPU's audio system";
          type = lib.types.str;
        };

        hd-audio = lib.mkOption {
          description = "The QEMU KVM identifier for the passthrough audio device";
          type = lib.types.str;
        };
      };

      vm-memory = lib.mkOption {
        description = "The amount of memory to assign to a given VM with passthrough, in MiB";
        type = lib.types.int;
      };
    };
  };

  config = lib.mkIf config.software.virtualization.kvm.enable {
    assertions = lib.optional config.software.virtualization.kvm.vfio-passthrough.enable {
      assertion = config.software.virtualization.kvm.enable;
      message = "QEMU KVM is required to enable VFIO passthrough";
    };

    boot = {
      extraModprobeConfig = "options kvm_${config.software.virtualization.cpu-type} nested=1";
      kernelModules = lib.optionals config.software.virtualization.kvm.vfio-passthrough.enable [
        "macvtap"
        "vfio_iommu_type1"
        "vfio_pci"
        "vfio"
      ];

      kernelParams = lib.optionals config.software.virtualization.kvm.vfio-passthrough.enable [
        "iommu=pt"
        "irqaffinity=${irq-affinity-threads}"
      ];
    };

    environment.systemPackages =
      (with pkgs; [
        ddcutil
        dnsmasq
        python314Packages.virt-firmware
      ])
      ++ (lib.optionals config.software.virtualization.kvm.vfio-passthrough.enable (with pkgs; [
        config.custom-packages.vfio-isolate
        config.custom-packages.vfio-tools
        dmidecode
        gawk
        hwloc
        util-linux
      ]));

    programs.virt-manager.enable = any-user-has-desktop-environments-enabled;
    system.activationScripts.install-libvirt-hooks.text = lib.mkIf config.software.virtualization.kvm.vfio-passthrough.enable ''
      cp -f ${config.custom-packages.vfio-scripts.hooks-common} /var/lib/libvirt/hooks/hooks-common.sh
      mkdir -p /var/lib/libvirt/hooks/hook-examples
      cp ${config.custom-packages.vfio-tools}/bin/qemu /var/lib/libvirt/hooks/qemu
      cp ${config.custom-packages.vfio-tools}/hooks/* /var/lib/libvirt/hooks/hook-examples
    '';

    systemd.services.libvirtd-set-info-logging = {
      enable = true;
      description = "Set logging to info level with file output";
      after = [
        "libvirtd.service"
        "multi-user.target"
      ];

      serviceConfig = {
        ExecStart = [
          ''${pkgs.libvirt}/bin/virt-admin -c libvirtd:///system daemon-log-outputs "3:journald 2:file:/var/log/libvirt/libvirtd.log"''
          ''${pkgs.libvirt}/bin/virt-admin -c libvirtd:///system daemon-log-filters "3:remote 4:event 3:util.json 3:util.object 3:util.dbus 3:util.netlink 3:node_device 3:rpc 3:access 2:*"''
          "${pkgs.libvirt}/bin/virt-admin -c libvirtd:///system daemon-timeout --timeout 0"
        ];

        Restart = "no";
        Type = "oneshot";
      };

      wantedBy = [ "multi-user.target" ];
    };

    users.extraUsers = builtins.listToAttrs (map (user: {
      name = user;
      value = {
        extraGroups = [ "libvirtd" ];
      };
    }) (builtins.attrNames config.home-manager.users));

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };

      spiceUSBRedirection.enable = true;
    };
  };
}
