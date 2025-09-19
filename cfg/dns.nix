
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  options.agondek-cfg.dnsmasq = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, host machine will use dnsmasq
        with default overwrite for wg and friends.
      '';
    };

    customAddresses = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    customServers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf cfg.dnsmasq.enable {
    networking.nameservers = lib.mkForce [
      "127.0.0.1"
    ];
    services.dnsmasq = {
      enable = true;
      settings = {
        listen-address = "127.0.0.1";
        cache-size = "250";
        server = [
          # cloudflare
          "1.1.1.1"
          "1.0.0.1"
          # g-evil
          "8.8.8.8"
        ] ++ cfg.dnsmasq.customServers;
        address = cfg.dnsmasq.customAddresses;
      };
      alwaysKeepRunning = true;
      resolveLocalQueries = true;
    };
  };
}
