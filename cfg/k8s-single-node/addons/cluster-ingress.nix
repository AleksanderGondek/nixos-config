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
    services.kubernetes.addonManager.addons.cluster-ingress-ns = {
      apiVersion = "v1";
      kind = "Namespace";
      metadata = {
        name = "cluster-ingress";
        labels = {
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-sa = {
      apiVersion = "v1";
      automountServiceAccountToken = true;
      kind = "ServiceAccount";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx";
        namespace = "cluster-ingress";
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-cm = {
      apiVersion = "v1";
      data = null;
      kind = "ConfigMap";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-controller";
        namespace = "cluster-ingress";
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-cluster-role = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        labels = {
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx";
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
          apiGroups = ["extensions" "networking.k8s.io"];
          resources = ["ingresses"];
          verbs = ["get" "list" "watch"];
        }
        {
          apiGroups = [""];
          resources = ["events"];
          verbs = ["create" "patch"];
        }
        {
          apiGroups = ["extensions" "networking.k8s.io"];
          resources = ["ingresses/status"];
          verbs = ["update"];
        }
        {
          apiGroups = ["networking.k8s.io"];
          resources = ["ingressclasses"];
          verbs = ["get" "list" "watch"];
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-cluster-role-binding = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        labels = {
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "nginx-ingress-ingress-nginx";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "nginx-ingress-ingress-nginx";
          namespace = "cluster-ingress";
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-role = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx";
        namespace = "cluster-ingress";
      };
      rules = [
        {
          apiGroups = [""];
          resources = ["namespaces"];
          verbs = ["get"];
        }
        {
          apiGroups = [""];
          resources = ["configmaps" "pods" "secrets" "endpoints"];
          verbs = ["get" "list" "watch"];
        }
        {
          apiGroups = [""];
          resources = ["services"];
          verbs = ["get" "list" "watch"];
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
        {
          apiGroups = ["networking.k8s.io"];
          resources = ["ingressclasses"];
          verbs = ["get" "list" "watch"];
        }
        {
          apiGroups = [""];
          resourceNames = ["ingress-controller-leader-nginx"];
          resources = ["configmaps"];
          verbs = ["get" "update"];
        }
        {
          apiGroups = [""];
          resources = ["configmaps"];
          verbs = ["create"];
        }
        {
          apiGroups = [""];
          resources = ["events"];
          verbs = ["create" "patch"];
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-role-binding = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "RoleBinding";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx";
        namespace = "cluster-ingress";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "nginx-ingress-ingress-nginx";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "nginx-ingress-ingress-nginx";
          namespace = "cluster-ingress";
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-controller-admission-svc = {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-controller-admission";
        namespace = "cluster-ingress";
      };
      spec = {
        ports = [
          {
            name = "https-webhook";
            port = 443;
            targetPort = "webhook";
          }
        ];
        selector = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
        };
        type = "ClusterIP";
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-controller-svc = {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        annotations = null;
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-controller";
        namespace = "cluster-ingress";
      };
      spec = {
        ports = [
          {
            name = "http";
            port = 80;
            protocol = "TCP";
            targetPort = "http";
          }
          {
            name = "https";
            port = 443;
            protocol = "TCP";
            targetPort = "https";
          }
        ];
        selector = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
        };
        type = "LoadBalancer";
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-controller-deployment = {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-controller";
        namespace = "cluster-ingress";
      };
      spec = {
        minReadySeconds = 0;
        replicas = 1;
        revisionHistoryLimit = 10;
        selector = {
          matchLabels = {
            "app.kubernetes.io/component" = "controller";
            "app.kubernetes.io/instance" = "nginx-ingress";
            "app.kubernetes.io/name" = "ingress-nginx";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "controller";
              "app.kubernetes.io/instance" = "nginx-ingress";
              "app.kubernetes.io/name" = "ingress-nginx";
            };
          };
          spec = {
            containers = [
              {
                args = [
                  "/nginx-ingress-controller"
                  "--publish-service=$(POD_NAMESPACE)/nginx-ingress-ingress-nginx-controller"
                  "--election-id=ingress-controller-leader"
                  "--ingress-class=nginx"
                  "--configmap=$(POD_NAMESPACE)/nginx-ingress-ingress-nginx-controller"
                  "--validating-webhook=:8443"
                  "--validating-webhook-certificate=/usr/local/certificates/cert"
                  "--validating-webhook-key=/usr/local/certificates/key"
                ];
                env = [
                  {
                    name = "POD_NAME";
                    valueFrom = {fieldRef = {fieldPath = "metadata.name";};};
                  }
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {fieldPath = "metadata.namespace";};
                    };
                  }
                  {
                    name = "LD_PRELOAD";
                    value = "/usr/local/lib/libmimalloc.so";
                  }
                ];
                image = "k8s.gcr.io/ingress-nginx/controller:v0.48.1@sha256:e9fb216ace49dfa4a5983b183067e97496e7a8b307d2093f4278cd550c303899";
                imagePullPolicy = "IfNotPresent";
                lifecycle = {
                  preStop = {exec = {command = ["/wait-shutdown"];};};
                };
                livenessProbe = {
                  failureThreshold = 5;
                  httpGet = {
                    path = "/healthz";
                    port = 10254;
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 1;
                };
                name = "controller";
                ports = [
                  {
                    containerPort = 80;
                    name = "http";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 443;
                    name = "https";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 8443;
                    name = "webhook";
                    protocol = "TCP";
                  }
                ];
                readinessProbe = {
                  failureThreshold = 3;
                  httpGet = {
                    path = "/healthz";
                    port = 10254;
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 1;
                };
                resources = {
                  requests = {
                    cpu = "100m";
                    memory = "90Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = true;
                  capabilities = {
                    add = ["NET_BIND_SERVICE"];
                    drop = ["ALL"];
                  };
                  runAsUser = 101;
                };
                volumeMounts = [
                  {
                    mountPath = "/usr/local/certificates/";
                    name = "webhook-cert";
                    readOnly = true;
                  }
                ];
              }
            ];
            dnsPolicy = "ClusterFirst";
            hostNetwork = true;
            nodeSelector = {"kubernetes.io/os" = "linux";};
            serviceAccountName = "nginx-ingress-ingress-nginx";
            terminationGracePeriodSeconds = 300;
            volumes = [
              {
                name = "webhook-cert";
                secret = {secretName = "nginx-ingress-ingress-nginx-admission";};
              }
            ];
          };
        };
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-validating-webhook-config = {
      apiVersion = "admissionregistration.k8s.io/v1";
      kind = "ValidatingWebhookConfiguration";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission";
      };
      webhooks = [
        {
          admissionReviewVersions = ["v1" "v1beta1"];
          clientConfig = {
            service = {
              name = "nginx-ingress-ingress-nginx-controller-admission";
              namespace = "cluster-ingress";
              path = "/networking/v1beta1/ingresses";
            };
          };
          failurePolicy = "Fail";
          matchPolicy = "Equivalent";
          name = "validate.nginx.ingress.kubernetes.io";
          rules = [
            {
              apiGroups = ["networking.k8s.io"];
              apiVersions = ["v1beta1"];
              operations = ["CREATE" "UPDATE"];
              resources = ["ingresses"];
            }
          ];
          sideEffects = "None";
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-sa = {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        annotations = {
          "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission";
        namespace = "cluster-ingress";
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-cluster-role = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        annotations = {
          "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission";
      };
      rules = [
        {
          apiGroups = ["admissionregistration.k8s.io"];
          resources = ["validatingwebhookconfigurations"];
          verbs = ["get" "update"];
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-cluster-role-binding = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        annotations = {
          "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "nginx-ingress-ingress-nginx-admission";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "nginx-ingress-ingress-nginx-admission";
          namespace = "cluster-ingress";
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-role = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        annotations = {
          "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission";
        namespace = "cluster-ingress";
      };
      rules = [
        {
          apiGroups = [""];
          resources = ["secrets"];
          verbs = ["get" "create"];
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-role-binding = {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "RoleBinding";
      metadata = {
        annotations = {
          "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission";
        namespace = "cluster-ingress";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "nginx-ingress-ingress-nginx-admission";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "nginx-ingress-ingress-nginx-admission";
          namespace = "cluster-ingress";
        }
      ];
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-create-job = {
      apiVersion = "batch/v1";
      kind = "Job";
      metadata = {
        annotations = {
          "helm.sh/hook" = "pre-install,pre-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission-create";
        namespace = "cluster-ingress";
      };
      spec = {
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "admission-webhook";
              "app.kubernetes.io/instance" = "nginx-ingress";
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/version" = "0.48.1";
              "helm.sh/chart" = "ingress-nginx-3.35.0";
              "addonmanager.kubernetes.io/mode" = "Reconcile";
            };
            name = "nginx-ingress-ingress-nginx-admission-create";
          };
          spec = {
            containers = [
              {
                args = [
                  "create"
                  "--host=nginx-ingress-ingress-nginx-controller-admission,nginx-ingress-ingress-nginx-controller-admission.$(POD_NAMESPACE).svc"
                  "--namespace=$(POD_NAMESPACE)"
                  "--secret-name=nginx-ingress-ingress-nginx-admission"
                ];
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {fieldRef = {fieldPath = "metadata.namespace";};};
                  }
                ];
                image = "docker.io/jettech/kube-webhook-certgen:v1.5.1";
                imagePullPolicy = "IfNotPresent";
                name = "create";
              }
            ];
            restartPolicy = "OnFailure";
            securityContext = {
              runAsNonRoot = true;
              runAsUser = 2000;
            };
            serviceAccountName = "nginx-ingress-ingress-nginx-admission";
          };
        };
      };
    };
    services.kubernetes.addonManager.addons.cluster-ingress-nginx-admission-patch = {
      apiVersion = "batch/v1";
      kind = "Job";
      metadata = {
        annotations = {
          "helm.sh/hook" = "post-install,post-upgrade";
          "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
        };
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "nginx-ingress";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/version" = "0.48.1";
          "helm.sh/chart" = "ingress-nginx-3.35.0";
          "addonmanager.kubernetes.io/mode" = "Reconcile";
        };
        name = "nginx-ingress-ingress-nginx-admission-patch";
        namespace = "cluster-ingress";
      };
      spec = {
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "admission-webhook";
              "app.kubernetes.io/instance" = "nginx-ingress";
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/version" = "0.48.1";
              "helm.sh/chart" = "ingress-nginx-3.35.0";
              "addonmanager.kubernetes.io/mode" = "Reconcile";
            };
            name = "nginx-ingress-ingress-nginx-admission-patch";
          };
          spec = {
            containers = [
              {
                args = [
                  "patch"
                  "--webhook-name=nginx-ingress-ingress-nginx-admission"
                  "--namespace=$(POD_NAMESPACE)"
                  "--patch-mutating=false"
                  "--secret-name=nginx-ingress-ingress-nginx-admission"
                  "--patch-failure-policy=Fail"
                ];
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {fieldRef = {fieldPath = "metadata.namespace";};};
                  }
                ];
                image = "docker.io/jettech/kube-webhook-certgen:v1.5.1";
                imagePullPolicy = "IfNotPresent";
                name = "patch";
              }
            ];
            restartPolicy = "OnFailure";
            securityContext = {
              runAsNonRoot = true;
              runAsUser = 2000;
            };
            serviceAccountName = "nginx-ingress-ingress-nginx-admission";
          };
        };
      };
    };
  };
}
