{ pkgs ? import <nixpkgs> {} }:

{
  hashedPassword = "00000000000000000000000000000000"; #mkpasswd -m sha-512
  gitGpgSigningKey = "00000000000000000000000000000000";
  gitUserEmail = "john.doe@someemailprovider.com;
}