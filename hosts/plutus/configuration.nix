# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

    networking.hostName = "plutus"; # Define your hostname.
    networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.enp2s0.useDHCP = true;
    networking.interfaces.wlp3s0.useDHCP = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
    # Ensure thermald runs
    services.thermald.enable = true;

    # Never ever go to sleep, hibernate of something like that
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    # Root config
    users.users.root = {
      hashedPasswordFile = lib.mkDefault config.sops.secrets.agondek_password.path;
    };

    # Host-specific steam setup
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [libva];
    environment.systemPackages = with pkgs; [
      steam
    ];

    # Morrigna cluster wg
    networking.wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          listenPort = 50666;
          ips = [
            "192.168.66.8/24"
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
              publicKey = "nomrjGfbVySZ1Q2zdIEXxQ519oPR1nyrlCh7mhC0yCE=";
            }
            {
              # hetzner: bastion
              allowedIPs = ["192.168.66.7/32"];
              endpoint = "65.21.243.230:50666";
              publicKey = "5PqZsjsiXg9b/RThRxkzWL0EbuhWsoT4CmIlm7fS/TU=";
            }
            {
              # blackwood
              allowedIPs = ["192.168.66.4/32"];
              publicKey = "dYEcCG5IzzNxBcJPQM06rdN581RAfqU3EBV48awKvhQ=";
            }
          ];
          privateKeyFile = config.sops.secrets.morrigna_wg_private.path;
        };
      };
    };

    # Auto upgrade stable channel
    system.autoUpgrade = {
      enable = false;
    };
  };
}
