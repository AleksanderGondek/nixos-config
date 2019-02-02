{ lib, config, pkgs, ... }:

{
  documentation.man.enable = true;

  environment = {
    activationScripts = {
      # Configure various dotfiles.
      symlinks = stringAfter [ "users" ]
      ''
        ln -s ${pkgs.bash}/bin/bash /bin/bash || true
      '';
    };
    interactiveShellInit = ''
      export XDG_CONFIG_HOME="$HOME/.config"
      export QT_QPA_CONFIG_HOME="qt5ct"
      BASE16_SHELL="$HOME/.config/base16-shell/"
      export EDITOR=vim
      export VISUAL=vim
   '';
   systemPackages = with pkgs; [
     git
     wget
     vim
   ];
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    qt5ct.enable = true;
    zsh.enable = true;
  };

  system = {
    autoUpgrade.enable = true;
  };

  time = {
    timeZone = "Etc/UTC";
  };
}
