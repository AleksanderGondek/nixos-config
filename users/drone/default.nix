{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-nixos-config.users.drone;
  secrets = config.sops.secrets;
in {
  imports = [];

  options.agondek-nixos-config.users.drone = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, default drone user will be defined on the host.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.drone = {
      description = "Drone Utility Account";
      uid = 2137;
      isNormalUser = true;
      group = "nogroup";
      extraGroups = [
        "wheel"
      ];
      home = "/home/drone";
      shell = pkgs.bash;
      createHome = true;
      hashedPasswordFile = secrets.drone_password.path;
    };

    home-manager.users.drone = {
      home.stateVersion = "24.05";
      home.packages = with pkgs; [
        kubectl
        jq
        binutils
        gcc
        gnumake
        openssl
      ];
      home.sessionVariables = {
        NIXOS_CONFIG = /home/drone/projects/nixos-config;
        EDITOR = "vim";
      };
    };

    nix.settings.trusted-users = ["drone"];
  };
}
