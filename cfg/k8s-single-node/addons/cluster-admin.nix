{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  config = lib.mkIf cfg.k8s-single-node.enable {
    services.kubernetes.addonManager.addons.cluster-admin-service-account = {
      kind = "ServiceAccount";
      apiVersion = "v1";
      metadata = {
        name = "cluster-admin-sa";
        namespace = "kube-system";
        labels = {
          # Custom modification, needed to make it work
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
      };
    };

    services.kubernetes.addonManager.addons.cluster-admin-cluster-role-binding = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cluster-admin-sa-role-binding";
        labels = {
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "cluster-admin";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "cluster-admin-sa";
          namespace = "kube-system";
        }
      ];
    };
  };
}
