{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ./bootstrap-secrets.nix
    ./audio
    ./desktop
    ./fonts
    ./k8s-single-node
    ./users
    ./virtualisation
  ];

  options.agondek-cfg.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, the host machine will be configured to support
        desktop mode (aka. not only terminal console).
      '';
    };
    flavor = lib.mkOption {
      type = lib.types.enum ["default" "nvidia"];
      default = "default";
      description = ''
        What kind of desktop setup should be configured.
      '';
    };
  };
  options.agondek-cfg.nix = {
    channel = lib.mkOption {
      type = lib.types.str;
      default = "24.05";
      description = ''
        Nix channel / stateVersion.
      '';
    };
  };
}
