{ config, pkgs, ... }:

{
  imports = [
    ''${builtins.fetchGit {
      name = "home-manager";
      rev = "a334a941c40bf1618da86bb12517fd47c4836800";
      url = https://github.com/rycee/home-manager;
    }}/nixos''
  ];

  documentation.man.enable = true;

  environment = {
    interactiveShellInit = ''
      export XDG_CONFIG_HOME="$HOME/.config"
      export QT_QPA_CONFIG_HOME="qt5ct"
      BASE16_SHELL="$HOME/.config/base16-shell/"
      export EDITOR=vim
      export VISUAL=vim
    '';
    systemPackages = with pkgs; [
      bind  # nslookup, dig
      coreutils
      curl
      dos2unix
      file # Show file type
      git-lfs
      gitAndTools.gitFull
      gnupg
      home-manager
      htop
      iftop # Display bandwidth usage on a network interface
      iotop # Find out the processes doing the most IO
      ncurses
      nix-prefetch-scripts
      openssl
      ranger
      p7zip
      psmisc # Small useful utilities that use the proc filesystem
      stdenv
      strace
      sudo
      sysstat
      usbutils
      wget
      vim
   ];
  };

  hardware = {
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;

    # Enable 3D acceleration for 32bit applications (e.g. wine)
    opengl.driSupport32Bit = true;
    opengl.driSupport = true;
    opengl.enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    bash = {
      enableCompletion = true;
    };
    qt5ct.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      promptInit = "";
    };
  };

  services = {
    # dunst requirement
    dbus.socketActivated = true;

    locate = {
      enable = true;
      interval = "00 20 * * *";
    };

    # Infamous systemd screen/tmux killer W/A
    logind.extraConfig = ''
      KillUserProcesses=no
    '';

    nixosManual.showManual = false;
    ntp.enable = true;

    zfs.autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  sound = {
    enable = true;
  };

  system = {
    autoUpgrade.enable = true;
  };

  time = {
    timeZone = "Etc/UTC";
  };
}
