# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/nix" =
    { device = "rpool/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/etc" =
    { device = "rpool/nixos/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    { device = "rpool/nixos/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib" =
    { device = "rpool/nixos/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/log" =
    { device = "rpool/nixos/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    { device = "rpool/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/root" =
    { device = "rpool/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/456C-5FFD";
      fsType = "vfat";
      options = [ "X-mount.mkdir" ];
    };

  swapDevices =
    [ { 
        #device = "/dev/disk/by-uuid/1475d148-8cc0-40ee-b513-8934b58f337e";
        device = "/dev/disk/by-id/ata-INTEL_SSDSC2BW180A4_BTDA351600H61802GN-part3";
        randomEncryption = true;
      }
    ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
