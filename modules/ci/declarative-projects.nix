{
  lib,
  pkgs,
  config,
  ...
}:
# https://github.com/nix-community/infra/blob/master/services/hydra/declarative-projects.nix
{
  services.hydra.declarativeProjects = {
    agondek-nixos-config = {
      displayName = "AleksanderGondek NixOS Config";
      inputValue = "https://github.com/AleksanderGondek/nixos-config";
      specFile = "ci/spec.json";
      description = "NixOS configuration";
      homepage = "https://github.com/AleksanderGondek/nixos-config";
    };
  };
}
