{ pkgs ? import <nixpkgs> {} }:

{
  users = {
    agondek = {
      hashedPassword = "00000000000000000000000000000000"; #mkpasswd -m sha-512
      git = {
        gpgSigningKey = "00000000000000000000000000000000";
        email = "john.doe@someemailprovider.com";
      };
    };
  };
  work = {
    ntpServers = ["aaa.bbb.ccc"];
    vpnIngress = "vpn.alladin.eu";
  };
}