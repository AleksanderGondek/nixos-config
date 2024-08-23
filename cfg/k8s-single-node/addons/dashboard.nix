{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.agondek-cfg;
in
  # Adapted from: https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
  #
  # cat recommended.yaml | yq > recommended.yaml
  # nix repl
  # :p builtins.fromJSON (builtins.readFile "/tmp/recommended.json")
  # nixfmt
  {
    imports = [];

    config = lib.mkIf cfg.k8s-single-node.enable {
      services.kubernetes.addonManager.addons.kubernetes-dashboard-ns = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "kubernetes-dashboard";
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
        };
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-sa = {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kubernetes-dashboard";
        };
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-svc = {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kubernetes-dashboard";
        };
        spec = {
          ports = [
            {
              port = 443;
              targetPort = 8443;
            }
          ];
          selector = {k8s-app = "kubernetes-dashboard";};
        };
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-certs-secret = {
        apiVersion = "v1";
        kind = "Secret";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard-certs";
          namespace = "kubernetes-dashboard";
        };
        type = "Opaque";
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-csrf-secret = {
        apiVersion = "v1";
        data = {csrf = "";};
        kind = "Secret";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard-csrf";
          namespace = "kubernetes-dashboard";
        };
        type = "Opaque";
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-key-holder-secret = {
        apiVersion = "v1";
        kind = "Secret";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard-key-holder";
          namespace = "kubernetes-dashboard";
        };
        type = "Opaque";
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-settings-cm = {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard-settings";
          namespace = "kubernetes-dashboard";
        };
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-role = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "Role";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kubernetes-dashboard";
        };
        rules = [
          {
            apiGroups = [""];
            resourceNames = [
              "kubernetes-dashboard-key-holder"
              "kubernetes-dashboard-certs"
              "kubernetes-dashboard-csrf"
            ];
            resources = ["secrets"];
            verbs = ["get" "update" "delete"];
          }
          {
            apiGroups = [""];
            resourceNames = ["kubernetes-dashboard-settings"];
            resources = ["configmaps"];
            verbs = ["get" "update"];
          }
          {
            apiGroups = [""];
            resourceNames = ["heapster" "dashboard-metrics-scraper"];
            resources = ["services"];
            verbs = ["proxy"];
          }
          {
            apiGroups = [""];
            resourceNames = [
              "heapster"
              "http:heapster:"
              "https:heapster:"
              "dashboard-metrics-scraper"
              "http:dashboard-metrics-scraper"
            ];
            resources = ["services/proxy"];
            verbs = ["get"];
          }
        ];
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-cluster-role = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
        };
        rules = [
          {
            apiGroups = ["metrics.k8s.io"];
            resources = ["pods" "nodes"];
            verbs = ["get" "list" "watch"];
          }
        ];
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-role-binding = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "RoleBinding";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kubernetes-dashboard";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "Role";
          name = "kubernetes-dashboard";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "kubernetes-dashboard";
            namespace = "kubernetes-dashboard";
          }
        ];
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-cluster-role-binding = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "kubernetes-dashboard";
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "kubernetes-dashboard";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "kubernetes-dashboard";
            namespace = "kubernetes-dashboard";
          }
        ];
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-deployment = {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kubernetes-dashboard";
        };
        spec = {
          replicas = 1;
          revisionHistoryLimit = 10;
          selector = {matchLabels = {k8s-app = "kubernetes-dashboard";};};
          template = {
            metadata = {labels = {k8s-app = "kubernetes-dashboard";};};
            spec = {
              containers = [
                {
                  args = [
                    "--auto-generate-certificates"
                    "--namespace=kubernetes-dashboard"
                  ];
                  image = "kubernetesui/dashboard:v2.3.1";
                  imagePullPolicy = "Always";
                  livenessProbe = {
                    httpGet = {
                      path = "/";
                      port = 8443;
                      scheme = "HTTPS";
                    };
                    initialDelaySeconds = 30;
                    timeoutSeconds = 30;
                  };
                  name = "kubernetes-dashboard";
                  ports = [
                    {
                      containerPort = 8443;
                      protocol = "TCP";
                    }
                  ];
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    readOnlyRootFilesystem = true;
                    runAsGroup = 2001;
                    runAsUser = 1001;
                  };
                  volumeMounts = [
                    {
                      mountPath = "/certs";
                      name = "kubernetes-dashboard-certs";
                    }
                    {
                      mountPath = "/tmp";
                      name = "tmp-volume";
                    }
                  ];
                }
              ];
              nodeSelector = {"kubernetes.io/os" = "linux";};
              serviceAccountName = "kubernetes-dashboard";
              tolerations = [
                {
                  effect = "NoSchedule";
                  key = "node-role.kubernetes.io/master";
                }
              ];
              volumes = [
                {
                  name = "kubernetes-dashboard-certs";
                  secret = {secretName = "kubernetes-dashboard-certs";};
                }
                {
                  emptyDir = {};
                  name = "tmp-volume";
                }
              ];
            };
          };
        };
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-metrics-scrapper-svc = {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            k8s-app = "dashboard-metrics-scraper";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "dashboard-metrics-scraper";
          namespace = "kubernetes-dashboard";
        };
        spec = {
          ports = [
            {
              port = 8000;
              targetPort = 8000;
            }
          ];
          selector = {k8s-app = "dashboard-metrics-scraper";};
        };
      };
      services.kubernetes.addonManager.addons.kubernetes-dashboard-metrics-scrapper-deployment = {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          labels = {
            k8s-app = "dashboard-metrics-scraper";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "dashboard-metrics-scraper";
          namespace = "kubernetes-dashboard";
        };
        spec = {
          replicas = 1;
          revisionHistoryLimit = 10;
          selector = {matchLabels = {k8s-app = "dashboard-metrics-scraper";};};
          template = {
            metadata = {
              annotations = {
                "seccomp.security.alpha.kubernetes.io/pod" = "runtime/default";
              };
              labels = {k8s-app = "dashboard-metrics-scraper";};
            };
            spec = {
              containers = [
                {
                  image = "kubernetesui/metrics-scraper:v1.0.6";
                  livenessProbe = {
                    httpGet = {
                      path = "/";
                      port = 8000;
                      scheme = "HTTP";
                    };
                    initialDelaySeconds = 30;
                    timeoutSeconds = 30;
                  };
                  name = "dashboard-metrics-scraper";
                  ports = [
                    {
                      containerPort = 8000;
                      protocol = "TCP";
                    }
                  ];
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    readOnlyRootFilesystem = true;
                    runAsGroup = 2001;
                    runAsUser = 1001;
                  };
                  volumeMounts = [
                    {
                      mountPath = "/tmp";
                      name = "tmp-volume";
                    }
                  ];
                }
              ];
              nodeSelector = {"kubernetes.io/os" = "linux";};
              serviceAccountName = "kubernetes-dashboard";
              volumes = [
                {
                  emptyDir = {};
                  name = "tmp-volume";
                }
              ];
            };
          };
        };
      };
    };
  }
