{ config, lib, pkgs, ... }:

{
  # Ensure default inotify watches for files is high
  boot.kernel.sysctl = {
    "fs.file-max" = 9223372036854775807;  
    "fs.inotify.max_user_watches" = 524288; 
  };

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  # Ensure Home Manager plays well with flakes
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Clean up nix gc
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

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
  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];

  # Enable thermald by default
  services.thermald.enable = true;

  # Base packages
  environment.systemPackages = with pkgs; [
    bind
    coreutils-full
    cntr
    curl
    gitAndTools.gitFull
    gnupg
    gnutar
    gparted
    htop
    less
    lm_sensors
    ranger
    unzip
    (pkgs.callPackage ../programs/my_vim.nix {})
    wget
    xorg.xhost
    xterm
  ];

  # Bash settings
  programs.bash = {
    enableCompletion = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
    };
  };

  users.defaultUserShell = pkgs.bash;
  # Disallow user management sheneningans
  users.mutableUsers = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.05"; # Did you read the comment?
}
