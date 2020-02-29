{ config, pkgs, ... }:

let
  nurCombined = fetchTarball https://github.com/nix-community/nur-combined/archive/master.tar.gz;
  ffAddons = import ''${nurCombined}/repos/rycee/pkgs/firefox-addons/default.nix'' {
    fetchurl = pkgs.fetchurl; stdenv = pkgs.stdenv;
  };
in 
ffAddons
