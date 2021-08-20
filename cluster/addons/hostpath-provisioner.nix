{ config, lib, pkgs, ... }:

{
  services.kubernetes.addonManager.addons.hostpath-provisioner-cr = {
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    kind = "ClusterRole";
    metadata = {
      labels = { "addonmanager.kubernetes.io/mode" = "Reconcile"; };
      name = "kubevirt-hostpath-provisioner";
    };
    rules = [
      {
        apiGroups = [ "" ];
        resources = [ "nodes" ];
        verbs = [ "get" ];
      }
      {
        apiGroups = [ "" ];
        resources = [ "persistentvolumes" ];
        verbs = [ "get" "list" "watch" "create" "delete" ];
      }
      {
        apiGroups = [ "" ];
        resources = [ "persistentvolumeclaims" ];
        verbs = [ "get" "list" "watch" "update" ];
      }
      {
        apiGroups = [ "storage.k8s.io" ];
        resources = [ "storageclasses" ];
        verbs = [ "get" "list" "watch" ];
      }
      {
        apiGroups = [ "" ];
        resources = [ "events" ];
        verbs = [ "list" "watch" "create" "update" "patch" ];
      }
    ];
  };
  services.kubernetes.addonManager.addons.hostpath-provisioner-crb = {
    apiVersion = "rbac.authorization.k8s.io/v1";
    kind = "ClusterRoleBinding";
    metadata = {
      labels = { "addonmanager.kubernetes.io/mode" = "Reconcile"; };
      name = "kubevirt-hostpath-provisioner";
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "ClusterRole";
      name = "kubevirt-hostpath-provisioner";
    };
    subjects = [{
      kind = "ServiceAccount";
      name = "kubevirt-hostpath-provisioner-admin";
      namespace = "kubevirt-hostpath-provisioner";
    }];
  };
  services.kubernetes.addonManager.addons.hostpath-provisioner-ds = {
    apiVersion = "apps/v1";
    kind = "DaemonSet";
    metadata = {
      labels = {
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        k8s-app = "kubevirt-hostpath-provisioner";
      };
      name = "kubevirt-hostpath-provisioner";
      namespace = "kubevirt-hostpath-provisioner";
    };
    spec = {
      selector = {
        matchLabels = { k8s-app = "kubevirt-hostpath-provisioner"; };
      };
      template = {
        metadata = { labels = { k8s-app = "kubevirt-hostpath-provisioner"; }; };
        spec = {
          containers = [{
            env = [
              {
                name = "USE_NAMING_PREFIX";
                value = "false";
              }
              {
                name = "NODE_NAME";
                valueFrom = { fieldRef = { fieldPath = "spec.nodeName"; }; };
              }
              {
                name = "PV_DIR";
                value = "/var/kubernetes-volumes";
              }
            ];
            image = "quay.io/kubevirt/hostpath-provisioner";
            imagePullPolicy = "Always";
            name = "kubevirt-hostpath-provisioner";
            volumeMounts = [{
              mountPath = "/var/kubernetes-volumes";
              name = "pv-volume";
            }];
          }];
          serviceAccountName = "kubevirt-hostpath-provisioner-admin";
          volumes = [{
            hostPath = { path = "/var/kubernetes-volumes"; };
            name = "pv-volume";
          }];
        };
      };
    };
  };
  services.kubernetes.addonManager.addons.hostpath-provisioner-ns = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata = {
      labels = { "addonmanager.kubernetes.io/mode" = "Reconcile"; };
      name = "kubevirt-hostpath-provisioner";
    };
  };
  services.kubernetes.addonManager.addons.hostpath-provisioner-sa = {
    apiVersion = "v1";
    kind = "ServiceAccount";
    metadata = {
      labels = { "addonmanager.kubernetes.io/mode" = "Reconcile"; };
      name = "kubevirt-hostpath-provisioner-admin";
      namespace = "kubevirt-hostpath-provisioner";
    };
  };
  services.kubernetes.addonManager.addons.hostpath-provisioner-sc = {
    apiVersion = "storage.k8s.io/v1";
    kind = "StorageClass";
    metadata = {
      annotations = {
        "storageclass.kubernetes.io/is-default-class" = "true";
      };
      labels = { "addonmanager.kubernetes.io/mode" = "Reconcile"; };
      name = "kubevirt-hostpath-provisioner";
    };
    provisioner = "kubevirt.io/hostpath-provisioner";
    reclaimPolicy = "Delete";
    volumeBindingMode = "WaitForFirstConsumer";
  };
}
