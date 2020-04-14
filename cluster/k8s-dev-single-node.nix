{ config, pkgs, ... }:

let
  devClusterAdminCert = config.services.kubernetes.lib.mkCert {
    name = "admin";
    CN = "kubernetes-cluster-ca";
    fields = {
      O = "system:masters";
    };
  };
  devClusterAdminKubeConfig = config.services.kubernetes.lib.mkKubeConfig "admin" {
    server = config.services.kubernetes.apiserverAddress;
    certFile = devClusterAdminCert.cert;
    keyFile = devClusterAdminCert.key;
  };
in
{
  services.kubernetes = {
    roles = ["master" "node"];
    easyCerts = true;

    masterAddress = config.networking.hostName;
    kubelet.extraOpts = "--fail-swap-on=false";

    apiserver.authorizationMode = [ "RBAC" "Node" ];

    pki.certs = { 
      devClusterAdmin = devClusterAdminCert; 
    };

    addons.dns.replicas = 1;
    addons.dashboard = {
      enable = true;
      rbac = { 
        clusterAdmin = true;
        };
    };

  };

  systemd.services.docker.after = pkgs.lib.mkForce [ "flannel.service" ];
  networking.firewall.trustedInterfaces = [" flannel.1" ];

  home-manager.users.agondek.home.sessionVariables = {
    KUBECONFIG="${devClusterAdminKubeConfig}:$HOME/.kube/config";
  };

  imports = [
    ./addons/admin.nix
    ./addons/hostpath-provisioner.nix
    ./addons/ingress-nginx.nix
  ];
}
