{ pkgs ? import <nixpkgs> {} }:

{
  users = {
    agondek = {
      hashedPassword = "00000000000000000000000000000000"; #mkpasswd -m sha-512
      git = {
        gpgSigningKey = "00000000000000000000000000000000";
        email = "john.doe@someemailprovider.com";
      };
      hydra = {
        hashedPassword = ""; #mkpasswd -m sha-1
      };
    };
    drone = {
      hashedPassword = "00000000000000000000000000000000"; #mkpasswd -m sha-512
    };
  };
  work = {
    ntpServers = ["aaa.bbb.ccc"];
    vpnIngress = "vpn.alladin.eu";
  };
}