{ config, pkgs, ... }:

#
# Notes about installation
# ---
# 1. Remove dockerd before using this config 
#   (Otherwise you are in for some connectivity issues)
# 2. chmod 0644 /var/lib/kubernetes/secrets/admin-key.pem
# 

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
        enable = true;
        clusterAdmin = false;
      };
    };
  };
  
  # We need to apply this permissions, to use
  # addon-manager in a bit 'haxy' way - 
  # thanks to it, we can spin Ingress, Hostpath etc.
  # on cluster start.
  services.kubernetes.addonManager.bootstrapAddons = {
    # TODO: Investigate and drop privileges not neeeded
    kube-addon-manager-allow-all = {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kube-addon-manager-allow-all";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "cluster-admin";
      };
      subjects = [
        {
          kind  = "User";
          name = "system:kube-addon-manager";
        }
      ];
    };
    ingress-nginx-namespace = {
      kind = "Namespace";
      apiVersion = "v1";
      metadata = {
        name = "ingress-nginx";
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/part-of" = "ingress-nginx";
        };
      };
    };
  };

  systemd.services.docker.after = pkgs.lib.mkForce [ "flannel.service" ];
  networking.firewall.trustedInterfaces = [" flannel.1" ];

  # TODO: Find more elegant solution
  environment.variables = {
    KUBECONFIG="${devClusterAdminKubeConfig}:$HOME/.kube/config";
  };
  home-manager.users.agondek.home.sessionVariables = {
    KUBECONFIG="${devClusterAdminKubeConfig}:$HOME/.kube/config";
  };

  imports = [
    ./addons/admin.nix
    ./addons/hostpath-provisioner.nix
    ./addons/ingress-nginx.nix
  ];
}
