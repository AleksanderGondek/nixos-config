{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = {
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

    # "v4l2loopback" -> virtualcam for OBS
    # boot.kernelModules = [ "v4l2loopback" ];
    # boot.extraModulePackages = with config.boot.kernelPackages; [
    #   v4l2loopback
    # ];
    # Counter-act intel sheneningans
    boot.kernelParams = ["module_blacklist=i915"];
    # Emulate aarch64
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    # ZFS requirements
    networking.hostId = "4746a27b";
    # Network (Wireless and cord)
    networking.hostName = "blackwood";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.eno1.useDHCP = true;
    networking.resolvconf.enable = true;

    # Never ever go to sleep, hibernate of something like that
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    nix.extraOptions = ''
      builders-use-substitutes = true
    '';

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
            "192.168.66.4/24"
          ];
          peers = [
            {
              # morrigna cluster: anand
              allowedIPs = ["192.168.66.1/32"];
              endpoint = "135.181.3.156:50666";
              publicKey = "tcszG32OvcAonkgDCMNlai9rxCIiKCdFlKtfy0Zj50A=";
            }
            {
              # morrigna cluster: badb
              allowedIPs = ["192.168.66.2/32"];
              endpoint = "65.21.132.30:50666";
              publicKey = "5xYDKu3euQchK0E/LBaUcus65tWioxnvhWCkkyfI9QU=";
            }
            {
              # morrigna cluster: macha
              allowedIPs = ["192.168.66.3/32"];
              endpoint = "65.108.13.183:50666";
              publicKey = "c/8phQmj5DDd3O0xPFY/VStv1KnsX8yS5n+eQZ3s+xQ=";
            }
            {
              # github-actions
              allowedIPs = ["192.168.66.5/32"];
              publicKey = "2gcoMsOvpcTTX/UQym8nH4I9KY4f+Q8gvP8+FFlrVAs=";
            }
            {
              # r2r-dev
              allowedIPs = ["192.168.66.6/32"];
              endpoint = "83.23.70.248:51820";
              publicKey = "nomrjGfbVySZ1Q2zdIEXxQ519oPR1nyrlCh7mhC0yCE=";
            }
            {
              # hetzner: bastion
              allowedIPs = ["192.168.66.7/32"];
              endpoint = "65.21.243.230:50666";
              publicKey = "5PqZsjsiXg9b/RThRxkzWL0EbuhWsoT4CmIlm7fS/TU=";
            }
          ];
          privateKeyFile = config.sops.secrets.morrigna_wg_private.path;
        };
      };
    };

    services.openssh = {
      enable = true;

      banner = "Welcome to blackwood.home.other-songs.eu!\n";
      openFirewall = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StrictModes = true;
        UsePAM = false;
      };
    };

    services.xrdp = {
      enable = true;
      openFirewall = true;
      #defaultWindowManager = "i3";
    };

    # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/os-specific/linux/nvidia-x11/default.nix
    # NVIDIA driver > 515 have broken daisy-chained DP
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Host-specific steam setup
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [libva];
    environment.systemPackages = with pkgs; [
      steam
    ];
  };
}
