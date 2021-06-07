{ config, pkgs, ... }:

let
  homeManager = fetchTarball https://github.com/rycee/home-manager/archive/release-21.05.tar.gz;
  secrets = import ../secrets.nix {};
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
in
{
  imports = [ 
    # Home Manager Enablement
    ''${homeManager}/nixos''
    # Temporary fix for 'gc-check-reachability no longer exists' error in hydra-send-stats
    # Additionally until https://github.com/NixOS/hydra/pull/895 is merged, sends stats does not work
    ''${unstableTarball}/nixos/modules/services/continuous-integration/hydra/default.nix''
  ];

  disabledModules = [ ''services/continuous-integration/hydra/default.nix'' ];

  # Ensure default inotify watches for files is high
  boot.kernel.sysctl = {
    "fs.file-max" = 9223372036854775807;  
    "fs.inotify.max_user_watches" = 524288; 
  };

  # Set limits for esync.
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];

  services.thermald.enable = true;

  # Clean up nix gc
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Enable experimental support for flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Add unstable packages under path pkgs.unstable.<pkg_name>
  nixpkgs = {
    config = {
      packageOverrides = pkgs: { inherit unstable; };
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = "pl";

  # Enable firewall explicitly  
  networking.firewall.enable = true;

  # Network (Wireless and cord)
  networking.networkmanager.enable = true;

  # DNS Resolution
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Allow unfree nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Base packages
  environment.systemPackages = with pkgs; [
    bind
    busybox
    curl
    gitAndTools.gitFull
    gnupg
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

  users.defaultUserShell = pkgs.bash;
  # Disallow user management sheneningans
  users.mutableUsers = false;
  # Root config
  users.users.root = {
    hashedPassword = secrets.users.agondek.hashedPassword;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?
}
