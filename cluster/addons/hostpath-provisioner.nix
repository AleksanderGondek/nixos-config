{ config, lib, pkgs, ... }:

{
  # https://github.com/MaZderMind/hostpath-provisioner/blob/master/manifests/rbac.yaml
  services.kubernetes.addonManager.addons.provisioner-clusterRole = {
    kind = "ClusterRole";
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    metadata = {
      name = "hostpath-provisioner";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
      };
    };
    rules = [
      {
        apiGroups = [""];
        resources = ["persistentvolumes"];
        verbs = ["get" "list" "watch" "create" "delete"];
      }
      {
        apiGroups = [""];
        resources = ["persistentvolumeclaims"];
        verbs = ["get" "list" "watch" "update"];
      }
      {
        apiGroups = ["storage.k8s.io"];
        resources = ["storageclasses"];
        verbs = ["get" "list" "watch"];
      }
      {
        apiGroups = [""];
        resources = ["events"];
        verbs = ["list" "watch" "create" "update" "patch"];
      }
    ];
  };

  services.kubernetes.addonManager.addons.provisioner-clusterRoleBinding = {
    kind = "ClusterRoleBinding";
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    metadata = {
      name="hostpath-provisioner";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
      };
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "ClusterRole";
      name = "hostpath-provisioner";
    };
    subjects = [
      {
        kind = "ServiceAccount";
        name = "default";
        namespace = "kube-system";
      }
    ];
  };

  #https://github.com/MaZderMind/hostpath-provisioner/blob/master/manifests/deployment.yaml
  services.kubernetes.addonManager.addons.provisioner-deployment = {
    apiVersion="apps/v1";
    kind="Deployment";
    metadata = {
      name="hostpath-provisioner";
      namespace = "kube-system";
      labels = {
        "k8s-app" = "hostpath-provisioner";
        "addonmanager.kubernetes.io/mode" = "Reconcile";
      };
    };
    spec = {
      replicas = 1;
      revisionHistoryLimit = 0;

      selector = {
        matchLabels = {
          "k8s-app" = "hostpath-provisioner";
        };
      };

      template = {
        metadata = {
          labels = {
            "k8s-app" = "hostpath-provisioner";
          };
        };

        spec = {
          containers = [
            {
              name = "hostpath-provisioner";
              image = "mazdermind/hostpath-provisioner:latest";
              env = [
                {
                  name = "NODE_NAME";
                  valueFrom = {
                    fieldRef = {
                        fieldPath="spec.nodeName";
                      };
                    };
                }
                {
                  name="PV_DIR";
                  value="/var/kubernetes";
                }
              ];
              volumeMounts = [
                {
                  name="pv-volume";
                  mountPath="/var/kubernetes";
                }
              ];
            }
          ];

          volumes = [
            {
              name="pv-volume";
              hostPath = {
                path="/var/kubernetes";
              };
            }
          ];
        };
      };
    };
  };

  # https://github.com/MaZderMind/hostpath-provisioner/blob/master/manifests/storageclass.yaml
  services.kubernetes.addonManager.addons.provisioner-sc = {
    kind = "StorageClass";
    provisioner = "hostpath";
    apiVersion = "storage.k8s.io/v1";
    metadata = {
      name = "hostpath";
      annotations = {
        "storageclass.kubernetes.io/is-default-class" = "true";
      };
      labels = {
        "addonmanager.kubernetes.io/mode" = "Reconcile";
      };
    };
  };
}
