{ config, pkgs, ... }:

{
  virtualisation.containerd = {
    enable = true;
    settings = {
      version = 2;
      root = "/var/lib/containerd";
      state = "/run/containerd";
      oom_score = 0;

      grpc = {
        address = "/run/containerd/containerd.sock";
      };

      plugins."io.containerd.grpc.v1.cri" = {
        sandbox_image = "pause:latest";

        cni = {
          bin_dir = "/opt/cni/bin";
          max_conf_num = 0;
        };

        containerd.runtimes.runc = {
          runtime_type = "io.containerd.runc.v2";
        };

        containerd.runtimes."io.containerd.runc.v2".options = {
          SystemdCgroup = true;
        };
      };
    };
  };
}
