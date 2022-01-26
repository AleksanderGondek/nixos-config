# nixos-config
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Collection of configuration files / scripts to setup my NixOS instances

### Hosts configurations health

| Name         | CI Status |
|--------------|-----------|
| blackwood | ![](https://github.com/AleksanderGondek/nixos-config/workflows/blackwood/badge.svg) |
| nixos-flake-test | ![](https://github.com/AleksanderGondek/nixos-config/workflows/nixos-flake-test/badge.svg) |
| ravenrock | ![](https://github.com/AleksanderGondek/nixos-config/workflows/ravenrock/badge.svg) |
| vm-utility-drone | ![](https://github.com/AleksanderGondek/nixos-config/workflows/vm-utility-drone/badge.svg) |


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

    # For /home and /root
    # (otherwise secrets do not work)
    neededForBoot = true;

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

### Secrets setup

For a host (run for root)
1. Create ssh ed25519 key via `ssh-keygen -t ed25519` or copy it from backup
2. Create sops-age directory via `mkdir -p ~/.config/sops/age`
3. Convert ssh to age key `nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"`
4. Ensure public age key derived from ssh pub key is present in the `.sops.yaml` (check public key via `nix-shell -p ssh-to-age --run 'cat ~/.ssh/id_ed25519.pub | ssh-to-age'`)

#### Users passwords
mkpasswd -m sha-512 -> secrets/file.yaml # passwordFile has to contained hashed value!
