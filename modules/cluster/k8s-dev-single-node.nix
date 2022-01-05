{ config, pkgs, ... }:

let
  clusterAdminCert = config.services.kubernetes.lib.mkCert {
    name = "cluster-admin";
    CN = "kubernetes-cluster-ca";
    fields = {
      O = "system:masters";
    };
  };
  clusterAdminKubeConfig = config.services.kubernetes.lib.mkKubeConfig "cluster-admin" {
    server = config.services.kubernetes.apiserverAddress;
    certFile = clusterAdminCert.cert;
    keyFile = clusterAdminCert.key;
  };
in
{
  # As this is dev setup, value expediency over stability
  systemd.services.containerd.serviceConfig.KillMode = pkgs.lib.mkForce "mixed";
  systemd.services.flannel.serviceConfig.TimeoutSec = 10;
  systemd.services.kube-apiserver .serviceConfig.TimeoutSec = 10;

  systemd.services.containerd.after = pkgs.lib.mkForce [ "flannel.service" ];
  networking.firewall.trustedInterfaces = [ "flannel.1" "mynet" ];

  environment.variables = {
    KUBECONFIG="${clusterAdminKubeConfig}:$HOME/.kube/config";
  };
  home-manager.users.agondek.home.sessionVariables = {
    KUBECONFIG="${clusterAdminKubeConfig}:$HOME/.kube/config";
  };

  users.groups = {
    kubernet = {
      members = [
      "agondek"
      "root"
      "kubernet"
      ];
    };
  };
  systemd.services.kubernetes-admin-key-permissions = {
    description = "Ensure k8s dev cluster admin key may easily accessed";
    wantedBy = [ "multi-user.target" ];
    requires = [ "kubernetes.slice" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      chown :kubernet /var/lib/kubernetes/secrets/cluster-admin.pem
      chmod g+r /var/lib/kubernetes/secrets/cluster-admin.pem
      chown :kubernet /var/lib/kubernetes/secrets/cluster-admin-key.pem
      chmod g+r /var/lib/kubernetes/secrets/cluster-admin-key.pem
    '';
  };

  services.kubernetes = {
    roles = ["master" "node"];

    masterAddress = config.networking.hostName;
    kubelet.extraOpts = "--fail-swap-on=false";

    apiserver.authorizationMode = [ "RBAC" "Node" ];
    apiserver.allowPrivileged = true;

    pki.certs = { 
      devClusterAdmin = clusterAdminCert; 
    };

    addons.dns.replicas = 1;
    addons.dashboard.enable = false;
  };
  
  # Ensure addon-manager can literally do anything
  services.kubernetes.addonManager.bootstrapAddons = {
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
  };

  imports = [
    ./addons/cluster-admin.nix
    ./addons/cluster-ingress.nix
    ./addons/dashboard.nix
    ./addons/hostpath-provisioner.nix
  ];
}
