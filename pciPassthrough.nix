# Courtesy of https://gist.github.com/techhazard/1be07805081a4d7a51c527e452b87b26
{config, pkgs, lib, ... }:

with lib;
let
cfg = config.pciPassthrough;

reduce = f: init: xs: builtins.foldl' (a: b: f a b) init xs;

getFileName = s:  (replaceStrings [" "] ["" ] s);

getUSBDeviceFileConfig = devices: (reduce
  (cfgMap: {vendorId, productId, name, ...}:
    (recursiveUpdate cfgMap {
      "virt/${(getFileName name)}.xml".text = ''
        <hostdev mode='subsystem' type='usb'>
          <source>
            <vendor id='0x${vendorId}'/>
            <product id='0x${productId}'/>
          </source>
        </hostdev>
      '';
    }))
  {}
  devices);

getUSBUdevRules = devices: (reduce
  (rulesStr: {vendorId, productId, name, vmName, ...}:
    (rulesStr + ''
      ACTION=="add", \
        SUBSYSTEM=="usb", \
        ATTRS{idVendor}=="${vendorId}", \
        ATTRS{idProduct}=="${productId}", \
        RUN+="${pkgs.libvirt}/bin/virsh attach-device ${vmName} /etc/virt/${(getFileName name)}.xml"
      ACTION=="remove", \
        SUBSYSTEM=="usb", \
        ATTRS{idVendor}=="${vendorId}", \
        ATTRS{idProduct}=="${productId}", \
        RUN+="${pkgs.libvirt}/bin/virsh detach-device ${vmName} /etc/virt/${(getFileName name)}.xml"
      ''))
  ""
  devices);

in
{
  ###### interface
  options.pciPassthrough = {
    enable = mkEnableOption "PCI Passthrough";

    cpuType = mkOption {
      description = "One of `intel` or `amd`";
      default = "intel";
      type = types.str;
    };

    pciIDs = mkOption {
      description = "Comma-separated list of PCI IDs to pass-through";
      type = types.str;
    };

    libvirtUsers = mkOption {
      description = "Extra users to add to libvirtd (root is already included)";
      type = types.listOf types.str;
      default = [];
    };
    audioUser = mkOption {
      default = "";
    };
    usbDevices = mkOption {
      default = [];
    };
  };

  ###### implementation
  config = (mkIf cfg.enable
    { boot.kernelParams = [ "${cfg.cpuType}_iommu=on" ];

      # These modules are required for PCI passthrough, and must come before early modesetting stuff
      boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

      boot.extraModprobeConfig ="options vfio-pci ids=${cfg.pciIDs}";

      environment.systemPackages = with pkgs; [
        virtmanager
        qemu
        OVMF
      ];

      environment.etc = (getUSBDeviceFileConfig cfg.usbDevices);
      services.udev.extraRules = (getUSBUdevRules cfg.usbDevices);

      virtualisation.libvirtd.enable = true;
      virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm;

      users.groups.libvirtd.members = [ "root" ] ++ cfg.libvirtUsers;

      virtualisation.libvirtd.qemuVerbatimConfig = ''
        nvram = [
        "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
        ]
        user = "${cfg.audioUser}"
      '';
    }
  );
}
