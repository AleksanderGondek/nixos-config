# nixos-config
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Collection of configuration files / scripts to setup my NixOS instances


### Disk setup

* `scripts/disk-setup.sh` - default way of preparing single-disk installation with ZFS as main partition
* required modification to nixos configuration:
  ```
  {

    # For each zfs entry
    fileSystems."/example" =
      { device = "rpool/entry";
        fsType = "zfs";
        # Add this line
        options = [ "zfsutil" ];
      };

    ...

    # For swap entries
    swapDevices = [
      { device = "/dev/disk/by-id/...";
        # Add this line
        randomEncryption = true;
      }

    ...

    # combat boot error external pointer tables not supported
    boot.loader.grub.copyKernels = true;
    # Disable hibernation explicitly
    boot.kernelParams = [ "nohibernate" ];
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.devNodes = "/dev/";
    #boot.zfs.requestEncryptionCredentials = true;

    services.zfs.autoScrub.enable = true;
    services.zfs.autoScrub.pools = [ "rpool" ];
    services.zfs.autoSnapshot.enable = true;
    services.zfs.trim.enable = true

    ...

    networking.hostId = "ffffffff";
    networking.hostName = "fffffffff";
  }

  ```