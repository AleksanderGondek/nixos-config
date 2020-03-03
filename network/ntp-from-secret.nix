# Replace default NTP servers with ones provided in secret file
{ config, pkgs, ... }:

let
  userSecrets = import ../user-secrets.nix {};
in
{
  # Enforce only provided ntp servers
  networking.timeServers = userSecrets.ntpServers;
}
