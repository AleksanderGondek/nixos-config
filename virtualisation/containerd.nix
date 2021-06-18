{ config, pkgs, ... }:

{
  virtualisation.containerd = {
    enable = true;
    configFile = pkgs.writeText "containerd.toml" ''
      version = 2
      root = "/var/lib/containerd"
      state = "/run/containerd"
      oom_score = 0

      [grpc]
        address = "/run/containerd/containerd.sock"
    '';
  };
}
