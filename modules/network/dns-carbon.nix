# Disallows any dynamic changes in resolv.conf (i.e. dhcp-provided nameservers)
{
  config,
  pkgs,
  ...
}: {
  # Enforce only nameservers from configuration
  # To be removed after: https://github.com/NixOS/nixpkgs/issues/61230 is resolved
  networking.networkmanager.dns = pkgs.lib.mkForce "none"; # networkmaneger not to overwrite /etc/resolv.conf
  services.resolved.enable = pkgs.lib.mkForce false; # just to be sure
  environment.etc."resolv.conf" = {
    text = pkgs.lib.optionalString (config.networking.nameservers != []) (
      pkgs.lib.concatMapStrings (ns: "nameserver ${ns}\n") config.networking.nameservers
    );
    mode = "0444";
  };
}
