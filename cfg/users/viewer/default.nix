{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
  secrets = config.sops.secrets;
in {
  imports = [];

  options.agondek-cfg.users.viewer = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, default viewer user will be defined on the host.
      '';
    };
  };

  config = lib.mkIf cfg.users.viewer.enable {
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
      home.stateVersion = cfg.nix.channel;
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
