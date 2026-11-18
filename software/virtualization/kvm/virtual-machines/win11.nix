{ config, lib, pkgs, ... }:

let
  mk-thread-string = type: builtins.concatStringsSep "," (map (thread: toString thread) config.software.virtualization.kvm.vfio-passthrough.cpu-threads.${type});
  vm-memory-kib = config.software.virtualization.kvm.vfio-passthrough.vm-memory * 1024;
  vm-emulator-cpus = mk-thread-string "emulator";
  vm-io-cpus = mk-thread-string "io";

  # NOTE:
  # This still hard references the 4090's vBIOS and the 24GB GPU workaround for QEMU
  # Likely need to break this out to modularize it to handle different GPUs
  xml-content = ''
    <domain type="kvm" xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
      <name>win11</name>
      <uuid>${config.sops.placeholder."virtualization/baseboard/uuid"}</uuid>
      <title>Windows 11</title>
      <description>Windows 11 virtual machine with hardware pass-through</description>
      <metadata>
        <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
          <libosinfo:os id="http://microsoft.com/win/11"/>
        </libosinfo:libosinfo>
      </metadata>
      <os firmware="efi">
        <type arch="x86_64" machine="pc-q35-10.2">hvm</type>
        <firmware>
          <feature enabled="no" name="enrolled-keys"/>
          <feature enabled="yes" name="secure-boot"/>
        </firmware>
        <loader readonly="yes" secure="yes" type="pflash" format="raw">/run/libvirt/nix-ovmf/edk2-x86_64-secure-code.fd</loader>
        <nvram template="/run/libvirt/nix-ovmf/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
        <smbios mode="sysinfo"/>
      </os>
      <features>
        <acpi/>
        <apic/>
        <hyperv mode="passthrough"/>
        <vmport state="off"/>
        <smm state="on"/>
      </features>
      <clock offset="localtime">
        <timer name="rtc" tickpolicy="catchup"/>
        <timer name="pit" tickpolicy="delay"/>
        <timer name="hpet" present="no"/>
        <timer name="hypervclock" present="yes"/>
      </clock>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>destroy</on_crash>
      <pm>
        <suspend-to-mem enabled="no"/>
        <suspend-to-disk enabled="no"/>
      </pm>
      ${xml-vm-memory}
      ${xml-cpu-config}
      ${xml-smbios}
      ${xml-devices-config}
      <qemu:commandline>
        <qemu:arg value='-fw_cfg'/>
        <qemu:arg value='opt/ovmf/X-PciMmio64Mb,string=65536'/>
      </qemu:commandline>
    </domain>
  '';

  xml-cpu-config =
    ''
      <vcpu placement="static">${toString (builtins.length config.software.virtualization.kvm.vfio-passthrough.cpu-threads.vm)}</vcpu>
      <iothreads>1</iothreads>
      <cputune>
    ''
    + (lib.concatStrings (map (thread-info: ''
      <vcpupin vcpu="${toString thread-info.vcpu}" cpuset="${toString thread-info.cpuset}"/>
    '') config.software.virtualization.kvm.vfio-passthrough.cpu-threads.vm))
    + ''
        <emulatorpin cpuset="${vm-emulator-cpus}"/>
        <iothreadpin iothread="1" cpuset="${vm-io-cpus}"/>
      </cputune>
      <cpu mode="host-passthrough" check="none" migratable="on">
        <topology sockets="1" dies="1" clusters="1" cores="${toString ((builtins.length config.software.virtualization.kvm.vfio-passthrough.cpu-threads.vm) / 2)}" threads="2"/>
        <cache mode="passthrough"/>
        <feature policy="require" name="topoext"/>
      </cpu>
    '';

  # NOTE:
  # This is tied to ridley pretty tightly still
  # Need to modularize this so that it can be somehow automated for any machine
  xml-devices-config = ''
    <devices>
      <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
      <disk type="file" device="disk">
        <driver name="qemu" type="qcow2"/>
        <source file="/var/lib/libvirt/images/win11.qcow2"/>
        <target dev="vda" bus="virtio"/>
        <boot order="1"/>
        <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
      </disk>
      <controller type="scsi" index="0" model="virtio-scsi">
        <driver queues="8" iothread="1"/>
        <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
      </controller>
      <controller type="usb" index="0" model="qemu-xhci" ports="15">
        <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
      </controller>
      <controller type="pci" index="0" model="pcie-root"/>
      <controller type="pci" index="1" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="1" port="0x10"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
      </controller>
      <controller type="pci" index="2" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="2" port="0x11"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
      </controller>
      <controller type="pci" index="3" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="3" port="0x12"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
      </controller>
      <controller type="pci" index="4" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="4" port="0x13"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
      </controller>
      <controller type="pci" index="5" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="5" port="0x14"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
      </controller>
      <controller type="pci" index="6" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="6" port="0x15"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x5"/>
      </controller>
      <controller type="pci" index="7" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="7" port="0x16"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x6"/>
      </controller>
      <controller type="pci" index="8" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="8" port="0x17"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x7"/>
      </controller>
      <controller type="pci" index="9" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="9" port="0x18"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x0" multifunction="on"/>
      </controller>
      <controller type="pci" index="10" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="10" port="0x19"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x1"/>
      </controller>
      <controller type="pci" index="11" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="11" port="0x1a"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x2"/>
      </controller>
      <controller type="pci" index="12" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="12" port="0x1b"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x3"/>
      </controller>
      <controller type="pci" index="13" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="13" port="0x1c"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x4"/>
      </controller>
      <controller type="pci" index="14" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="14" port="0x1d"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x5"/>
      </controller>
      <controller type="pci" index="15" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="15" port="0x1e"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x6"/>
      </controller>
      <controller type="pci" index="16" model="pcie-to-pci-bridge">
        <model name="pcie-pci-bridge"/>
        <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
      </controller>
      <controller type="sata" index="0">
        <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
      </controller>
      <controller type="virtio-serial" index="0">
        <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
      </controller>
      <interface type="direct">
        <mac address="52:54:00:98:83:b2"/>
        <source dev="enp6s0" mode="vepa"/>
        <model type="virtio"/>
        <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
      </interface>
      <input type="mouse" bus="ps2"/>
      <input type="keyboard" bus="ps2"/>
      <tpm model="tpm-tis">
        <backend type="emulator" version="2.0"/>
      </tpm>
      <hostdev mode="subsystem" type="pci" managed="yes">
        <source>
          <address domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
        </source>
        <rom file="/var/lib/libvirt/images/4090-vbios.rom"/>
        <address type="pci" domain="0x0000" bus="0x09" slot="0x00" function="0x0"/>
      </hostdev>
      <hostdev mode="subsystem" type="pci" managed="yes">
        <source>
          <address domain="0x0000" bus="0x01" slot="0x00" function="0x1"/>
        </source>
        <address type="pci" domain="0x0000" bus="0x0a" slot="0x00" function="0x0"/>
      </hostdev>
      <hostdev mode="subsystem" type="usb" managed="yes">
        <source>
          <vendor id="0x046d"/>
          <product id="0xc332"/>
        </source>
        <address type="usb" bus="0" port="4"/>
      </hostdev>
      <hostdev mode="subsystem" type="usb" managed="yes">
        <source>
          <vendor id="0x0c45"/>
          <product id="0x7692"/>
        </source>
        <address type="usb" bus="0" port="5"/>
      </hostdev>
      <hostdev mode="subsystem" type="pci" managed="yes">
        <source>
          <address domain="0x0000" bus="0x17" slot="0x00" function="0x6"/>
        </source>
        <address type="pci" domain="0x0000" bus="0x08" slot="0x00" function="0x0"/>
      </hostdev>
      <hostdev mode="subsystem" type="usb" managed="yes">
        <source startupPolicy="optional">
          <vendor id="0x28de"/>
          <product id="0x2432"/>
        </source>
        <address type="usb" bus="0" port="1"/>
      </hostdev>
      <watchdog model="itco" action="reset"/>
      <memballoon model="virtio">
        <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
      </memballoon>
    </devices>
  '';

  xml-smbios = ''
    <sysinfo type="smbios">
      <bios>
        <entry name="vendor">American Megatrends International, LLC.</entry>
        <entry name="version">1.L3</entry>
        <entry name="date">09/04/2026</entry>
        <entry name="release">5.41</entry>
      </bios>
      <system>
        <entry name="manufacturer">Micro-Star International Co., Ltd.</entry>
        <entry name="product">MS-7E12</entry>
        <entry name="version">1.0</entry>
        <entry name="serial">To be filled by O.E.M.</entry>
        <entry name="uuid">${config.sops.placeholder."virtualization/baseboard/uuid"}</entry>
        <entry name="sku">${config.sops.placeholder."virtualization/baseboard/sku"}</entry>
        <entry name="family">To be filled by O.E.M.</entry>
      </system>
      <baseBoard>
        <entry name="manufacturer">Micro-Star International Co., Ltd.</entry>
        <entry name="product">MAG X670E TOMAHAWK WIFI (MS-7E12)</entry>
        <entry name="version">1.0</entry>
        <entry name="serial">${config.sops.placeholder."virtualization/baseboard/serial"}</entry>
        <entry name="asset">To be filled by O.E.M.</entry>
      </baseBoard>
    </sysinfo>
  '';

  xml-vm-memory = ''
    <memory unit="KiB">${toString vm-memory-kib}</memory>
    <currentMemory unit="KiB">${toString vm-memory-kib}</currentMemory>
    <memoryBacking>
      <hugepages/>
    </memoryBacking>
  '';
in
{
  options.software.virtualization.kvm.virtual-machines.win11 = {
    enable = lib.mkEnableOption "Enables the Windows 11 virtual machine with VFIO passthrough";
  };

  config = lib.mkIf config.software.virtualization.kvm.virtual-machines.win11.enable {
    assertions = [
      {
        assertion = config.software.virtualization.kvm.vfio-passthrough.enable;
        message = "VFIO passthrough is required for the Windows 11 virtual machine";
      }
    ];

    sops = {
      secrets = {
        "virtualization/baseboard/serial" = {};
        "virtualization/baseboard/uuid" = {};
        "virtualization/baseboard/sku" = {};
      };

      templates = {
        "win11-machine.xml".content = xml-content;
      };
    };

    system.activationScripts.create-win11-vm.text = ''
      ${pkgs.libvirt}/bin/virsh define --file /run/secrets/rendered/win11-machine.xml
    '';

    # NOTE:
    # This is a workaround for hooks.
    #
    # SEE:
    # https://discourse.nixos.org/t/libvirt-installing-qemu-hook/385/7
    systemd.services.libvirtd.preStart = ''
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin
      cp -f ${config.custom-packages.vfio-scripts.isolate-cpus}/bin/isolate-cpus.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/isolate-cpus.sh
      cp -f ${config.custom-packages.vfio-scripts.alloc-hugepages}/bin/alloc-hugepages.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc-hugepages.sh
      cp -f ${config.custom-packages.vfio-scripts.start}/bin/start.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh

      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/release/end
      cp -f ${config.custom-packages.vfio-scripts.revert-cpu-isolation}/bin/revert-cpu-isolation.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/revert-cpu-isolation.sh
      cp -f ${config.custom-packages.vfio-scripts.dealloc-hugepages}/bin/dealloc-hugepages.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc-hugepages.sh
      cp -f ${config.custom-packages.vfio-scripts.revert}/bin/revert.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/revert.sh
    '';
  };
}
