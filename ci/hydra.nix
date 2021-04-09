# Skeleton setup for Hydra
{ config, pkgs, ... }:

let 
  secrets = import ../secrets.nix {};
  hydraHome = config.users.users.hydra.home;
  hydraQueueRunnerHome = config.users.users.hydra-queue-runner.home;
in
{
  services.hydra = {
    enable = true;
    # To be improved.
    hydraURL = "https://${config.networking.hostName}";
    notificationSender = "hydra@localhost";
    # Please use nix cache, otherwise build takes hours
    useSubstitutes = true;
    # A standalone hydra will require you to unset 
    # the buildMachinesFiles list to avoid using 
    # a nonexistant /etc/nix/machines
    buildMachinesFiles = [
    ];
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."example.com" =  {
      enableACME = false;
      forceSSL = false;

      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # required when the target is also TLS server with multiple hosts
          "proxy_ssl_server_name on;" +
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
          ;
      };
    };

  };

  nix.autoOptimiseStore = true;
  nix.trustedUsers = [
    "hydra"
    "hydra-evaluator"
    "hydra-queue-runner"
  ];

  systemd.services.hydra-prepare-admin-user = {
    after = [ 
      "hydra-init.service"
      "postgresql.service"
      "hydra.service" 
    ];
    wantedBy = [ "multi-user.target" ];
    description = "Prepare hydra admin user";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    environment = config.systemd.services.hydra-init.environment;
    script = ''
      ${config.services.hydra.package}/bin/hydra-create-user agondek --full-name 'Aleksander Gondek' \
        --email-address '${secrets.users.agondek.git.email}' \
        --password-hash ${secrets.users.agondek.hydra.hashedPassword} \
        --role admin

      # https://nix-dev.science.uu.narkive.com/fhPel9FQ/cannot-run-hydra-create-user-no-such-table-users
      # mkdir -p "${hydraHome}/.ssh"
      # chmod 700 "${hydraHome}/.ssh"
      # cp "*xxxx*" "${hydraHome}/.ssh/id_rsa"
      # chown -R hydra:hydra "${hydraHome}/.ssh"
      # chmod 600 "${hydraHome}/.ssh/id_rsa"
      # mkdir -p "${hydraQueueRunnerHome}/.ssh"
      # chmod 700 "${hydraQueueRunnerHome}/.ssh"
      # cp "*xxxx*" "${hydraQueueRunnerHome}/.ssh/id_rsa"
      # chown -R hydra-queue-runner:hydra "${hydraQueueRunnerHome}/.ssh"
      # chmod 600 "${hydraQueueRunnerHome}/.ssh/id_rsa"
    '';
  };
}
