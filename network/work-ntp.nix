# Ensure NTP servers used are those provided by company
{ config, pkgs, ... }:

let
  secrets = import ../secrets.nix {};
in
{
  # Enforce only provided ntp servers
  networking.timeServers = secrets.work.ntpServers;
}
