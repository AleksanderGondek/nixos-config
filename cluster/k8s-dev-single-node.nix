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

    apiserver.authorizationMode = [ "AlwaysAllow" "RBAC" "Node" ];
    apiserver.basicAuthFile = pkgs.writeText "users" ''
       kubernetes,admin,0,"cluster-admin"
    '';

    pki.certs = { 
      devClusterAdmin = devClusterAdminCert; 
    };

    addons.dns.replicas = 1;
    addons.dashboard = {
      extraArgs = ["--enable-skip-login"];
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

  # Bind created admin user to admin role
  services.kubernetes.addonManager.addons.admin-crb = {
    apiVersion="rbac.authorization.k8s.io/v1";
    kind = "ClusterRoleBinding";
    metadata = {
      labels = {
        "addonmanager.kubernetes.io/mode" = "Reconcile";
      };
      name = "cluster-admin-binding";
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "ClusterRole";
      name = "cluster-admin";
    };
    subjects = [
        {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "User";
          name = "admin";
        }
      ];
  };

  imports = [
    ./addons/hostpath-provisioner.nix
    ./addons/ingress-nginx.nix
  ];
}
