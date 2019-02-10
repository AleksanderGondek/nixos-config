{ config, pkgs, ... }:

{
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
      curl
      git-lfs
      gitAndTools.gitFull
      openssl
      stdenv
      strace
      sudo
      sysstat
      wget
      vim
   ];
  };

  hardware = {
    pulseaudio.enable = true;

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
    }
    qt5ct.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      promptInit = "";
    };
  };

  services = {
    locate = {
      enable = true;
      locate.interval = "00 20 * * *";
    }

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
