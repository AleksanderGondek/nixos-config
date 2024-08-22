{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-nixos-config.users.viewer;
  secrets = config.sops.secrets;
in {
  imports = [];

  options.agondek-nixos-config.users.viewer = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, default viewer user will be defined on the host.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.viewer = {
      description = "Pasithea Viewer Account";
      uid = 1331;
      isNormalUser = true;
      group = "nogroup";
      extraGroups = [
        "sound"
        "pulse"
        "audio"
      ];
      home = "/home/viewer";
      shell = pkgs.bash;
      createHome = true;
      hashedPasswordFile = config.sops.secrets.viewer_password.path;
    };

    home-manager.users.viewer = {
      home.stateVersion = "24.05";
      programs.firefox = {
        enable = true;
        enableGnomeExtensions = false;
      };
      home.packages = with pkgs; [
        coreutils
        eza
        fd
        fzf
        openssl
        plex
        ripgrep
        vim
      ];
      home.sessionVariables = {
        NIXOS_CONFIG = /home/drone/projects/nixos-config;
        EDITOR = "vim";
      };
    };
  };
}
