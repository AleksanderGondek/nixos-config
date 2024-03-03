{ config, lib, pkgs, ... }:

{
  # User related secrets
  # TOOD: There has to be a better way!
  sops.secrets.agondek_password = {
    sopsFile = ./secrets/agondek.yaml;
    neededForUsers = true;
  };
  sops.secrets.morrigna_wg_private = {
    sopsFile = ./secrets/agondek.yaml;
    neededForUsers = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e9053af22";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.copyKernels = true;

  boot.supportedFilesystems = [ "ntfs" ];

  # "v4l2loopback" -> virtualcam for OBS
  # boot.kernelModules = [ "v4l2loopback" ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   v4l2loopback
  # ];
  # Counter-act intel sheneningans
  boot.kernelParams = [ "module_blacklist=i915" ];
  # Emulate aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # ZFS requirements
  networking.hostId = "4746a27b";
  # Network (Wireless and cord)
  networking.hostName = "blackwood";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.resolvconf.enable = false;

  # Never ever go to sleep, hibernate of something like that
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  nix.buildMachines = [
    # tweag remote builder
    {
      hostName = "build01.tweag.io";
      maxJobs = 24;
      sshUser = "nix";
      sshKey = "/root/.ssh/agondek-id-tweag-builder";
      system = "x86_64-linux";
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
    }
  ];
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  # TODO: This is gonna be needed
  # services.tailscale.enable = true;

  # Root config
  users.users.root = {
    hashedPasswordFile = lib.mkDefault config.sops.secrets.agondek_password.path;
  };

  # Morrigna cluster wg
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        listenPort = 50666;
        ips = [
          "192.168.66.4/32"
        ];
        peers = [
          {
            allowedIPs = ["192.168.66.1/32"];
            endpoint = "135.181.3.156:50666";
            publicKey = "tcszG32OvcAonkgDCMNlai9rxCIiKCdFlKtfy0Zj50A=";
          }
          {
            allowedIPs = ["192.168.66.2/32"];
            endpoint = "65.21.132.30:50666";
            publicKey = "5xYDKu3euQchK0E/LBaUcus65tWioxnvhWCkkyfI9QU=";
          }
          {
            allowedIPs = ["192.168.66.3/32"];
            endpoint = "65.108.13.183:50666";
            publicKey = "c/8phQmj5DDd3O0xPFY/VStv1KnsX8yS5n+eQZ3s+xQ=";
          }
        ];
        privateKeyFile = config.sops.secrets.morrigna_wg_private.path;
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/os-specific/linux/nvidia-x11/default.nix
  # NVIDIA driver > 515 have broken daisy-chained DP
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = false;
  };
}
