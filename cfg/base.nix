{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  config = {
    # Ensure default inotify watches for files is high
    boot.kernel.sysctl = {
      "fs.file-max" = 9223372036854775807;
      "fs.inotify.max_user_watches" = 524288;
    };

    # TODO(agondek): make it an option
    # For now every host, uses ZFS
    # Remember to define:
    # networking.hostId
    # networking.hostName
    boot.supportedFilesystems = [
      "ntfs"
      "zfs"
    ];
    boot.zfs.devNodes = "/dev/";

    services.zfs.trim.enable = true;
    services.zfs.autoScrub = {
      enable = true;
      pools = ["rpool"];
    };

    services.zfs.autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
      frequent = 4;
      hourly = 6;
      daily = 3;
      weekly = 1;
      monthly = 1;
    };

    # Enable flakes
    nix = {
      package = pkgs.nixFlakes;
      extraOptions =
        pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
        "experimental-features = nix-command flakes";
    };

    # Clean up nix gc
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Ensure Home Manager plays well with flakes
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # Enable firewall explicitly
    networking.firewall.enable = true;
    # Network (Wireless and cord)
    networking.networkmanager.enable = true;
    # DNS Resolution
    networking.nameservers = [
      # Cloudflare
      "1.1.1.1"
      "1.0.0.1"
      # Gevil
      "9.9.9.9"
    ];

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
    };
    console.font = "Lat2-Terminus16";
    console.keyMap = "pl";

    # Set limits for esync.
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];

    # Enable thermald by default
    services.thermald.enable = true;

    # Base packages
    environment.systemPackages = with pkgs; [
      coreutils-full
      curl
      git
      gnupg
      gnutar
      gparted
      htop
      less
      lm_sensors
      unzip
      vim
      wget
    ];

    # Bash settings
    programs.bash = {
      enableCompletion = true;
    };

    users.defaultUserShell = pkgs.bash;
    # Disallow user management sheneningans
    users.mutableUsers = false;

    # Auto upgrade stable channel
    system.autoUpgrade = {
      enable = false;
    };
    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = cfg.nix.channel;
  };
}
