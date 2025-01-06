{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ./bootstrap-secrets.nix
    ./dns.nix
    ./audio
    ./desktop
    ./fonts
    ./k8s-single-node
    ./users
    ./virtualisation
  ];

  options.agondek-cfg.nix = {
    channel = lib.mkOption {
      type = lib.types.str;
      default = "24.11";
      description = ''
        Nix channel / stateVersion.
      '';
    };
  };
}
