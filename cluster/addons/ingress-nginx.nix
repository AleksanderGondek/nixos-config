{ config, lib, pkgs, ... }:

# Source: https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml

{
  services.kubernetes.addonManager.addons.ingress-namespace = {
    kind = "Namespace";
    apiVersion = "v1";
    metadata = {
      name = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
  };

  services.kubernetes.addonManager.addons.ingress-configMap-nginx = {
    kind = "ConfigMap";
    apiVersion = "v1";
    metadata = {
      name = "nginx-configuration";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
  };

  services.kubernetes.addonManager.addons.ingress-configMap-tcp = {
    kind = "ConfigMap";
    apiVersion = "v1";
    metadata = {
      name = "tcp-services";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
  };

  services.kubernetes.addonManager.addons.ingress-configMap-udp = {
    kind = "ConfigMap";
    apiVersion = "v1";
    metadata = {
      name = "udp-services";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
  };

  services.kubernetes.addonManager.addons.ingress-service-account = {
    kind = "ServiceAccount";
    apiVersion = "v1";
    metadata = {
      name = "nginx-ingress-serviceaccount";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
  };

  services.kubernetes.addonManager.addons.ingress-cluster-role = {
    kind = "ClusterRole";
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    metadata = {
      name = "nginx-ingress-clusterrole";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
    rules = [
      {
        apiGroups = [""];
        resources = ["configmaps" "endpoints" "nodes" "pods" "secrets"];
        verbs = ["list" "watch"];
      }
      {
        apiGroups = [""];
        resources = ["nodes"];
        verbs = ["get"];
      }
      {
        apiGroups = [""];
        resources = ["services"];
        verbs = ["get" "list" "watch"];
      }
      {
        apiGroups = [""];
        resources = ["events"];
        verbs = ["create" "patch"];
      }
      {
        apiGroups = ["extensions" "networking.k8s.io"];
        resources = ["ingresses"];
        verbs = ["get" "list" "watch"];
      }
      {
        apiGroups = ["extensions" "networking.k8s.io"];
        resources = ["ingresses/status"];
        verbs = ["update"];
      }
    ];
  };

  services.kubernetes.addonManager.addons.ingress-role = {
    kind = "Role";
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    metadata = {
      name = "nginx-ingress-role";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
    rules = [
      {
        apiGroups = [""];
        resources = ["configmaps" "pods" "secrets" "namespaces"];
        verbs = ["get"];
      }
      {
        apiGroups = [""];
        resources = ["configmaps"];
        # Defaults to "<election-id>-<ingress-class>"
        # Here: "<ingress-controller-leader>-<nginx>"
        # This has to be adapted if you change either parameter
        # when launching the nginx-ingress-controller.
        resourceNames = ["ingress-controller-leader-nginx"];
        verbs = ["get" "update"];
      }
      {
        apiGroups = [""];
        resources = ["configmaps"];
        verbs = ["create"];
      }
      {
        apiGroups = [""];
        resources = ["endpoints"];
        verbs = ["get"];
      }
    ];
  };

  services.kubernetes.addonManager.addons.ingress-cluster-role-binding = {
    kind = "ClusterRoleBinding";
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    metadata = {
      name = "nginx-ingress-clusterrole-nisa-binding";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "ClusterRole";
      name = "nginx-ingress-clusterrole";
    };
    subjects = [
      {
        kind = "ServiceAccount";
        name = "nginx-ingress-serviceaccount";
        namespace = "ingress-nginx";
      }
    ];
  };

  services.kubernetes.addonManager.addons.ingress-role-binding = {
    kind = "RoleBinding";
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    metadata = {
      name = "nginx-ingress-role-nisa-binding";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "Role";
      name = "nginx-ingress-role";
    };
    subjects = [
      {
        kind = "ServiceAccount";
        name = "nginx-ingress-serviceaccount";
        namespace = "ingress-nginx";
      }
    ];
  };

  services.kubernetes.addonManager.addons.ingress-deployment = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "nginx-ingress-controller";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/part-of" = "ingress-nginx";
        };
      };
      template = {
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "ingress-nginx";
            "app.kubernetes.io/part-of" = "ingress-nginx";
          };
          annotations = {
            "prometheus.io/port" = "10254";
            "prometheus.io/scrape" = "true";
          };
        };
        spec = {
          # https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#via-the-host-network
          hostNetwork = true;
          # wait up to five minutes for the drain of connections
          terminationGracePeriodSeconds = 300;
          serviceAccountName = "nginx-ingress-serviceaccount";
          nodeSelector = {
            "kubernetes.io/os" = "linux";
          };
          containers = [
            {
              name = "nginx-ingress-controller";
              image = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0";
              args = [
                "/nginx-ingress-controller"
                "--configmap=$(POD_NAMESPACE)/nginx-configuration"
                "--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services"
                "--udp-services-configmap=$(POD_NAMESPACE)/udp-services"
                "--publish-service=$(POD_NAMESPACE)/ingress-nginx"
                "--report-node-internal-ip-address"
                "--update-status"
                "--annotations-prefix=nginx.ingress.kubernetes.io"
              ];
              securityContext = {
                allowPrivilegeEscalation = true;
                capabilities = {
                  drop = ["ALL"];
                  add = ["NET_BIND_SERVICE"];
                  # www-data -> 101
                };
                runAsUser = 101;
              };
              env = [
                {
                  name = "POD_NAME";
                  valueFrom = {
                    fieldRef = {
                      fieldPath = "metadata.name";
                    };
                  };
                }
                {
                  name = "POD_NAMESPACE";
                  valueFrom = {
                    fieldRef = {
                      fieldPath = "metadata.namespace";
                    };
                  };
                }
              ];
              ports = [
                {
                  name = "http";
                  containerPort = 80;
                  protocol = "TCP";
                }
                {
                  name = "https";
                  containerPort = 443;
                  protocol = "TCP";
                }
              ];
              livenessProbe = {
                failureThreshold = 3;
                httpGet = {
                  path = "/healthz";
                  port = 10254;
                  scheme = "HTTP";
                };
                initialDelaySeconds = 10;
                periodSeconds = 10;
                successThreshold = 1;
                timeoutSeconds = 10;
              };
              readinessProbe = {
                failureThreshold = 3;
                httpGet = {
                  path = "/healthz";
                  port = 10254;
                  scheme = "HTTP";
                };
                periodSeconds = 10;
                successThreshold = 1;
                timeoutSeconds = 10;
              };
              lifecycle = {
                preStop = {
                  exec = {
                    command = [ "/wait-shutdown" ];
                  };
                };
              };
            }
          ];
        };
      };
    };
  };

  services.kubernetes.addonManager.addons.ingress-limitRange = {
    kind = "LimitRange";
    apiVersion = "v1";
    metadata = {
      name = "ingress-nginx";
      namespace = "ingress-nginx";
      labels = {
        # Custom modification, needed to make it work
        "addonmanager.kubernetes.io/mode" = "Reconcile";
        "app.kubernetes.io/name" = "ingress-nginx";
        "app.kubernetes.io/part-of" = "ingress-nginx";
      };
    };
    spec = {
      limits = [
        {
          min = {
            memory = "90Mi";
            cpi = "100m";
          };
          type = "Container";
        }
      ];
    };
  };
}
