{ pkgs ? import <nixpkgs> {} }:

let
  unstable = import (
    fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/90e09e1f0f003960f3feb28f67873774df8b0921.tar.gz;
      sha256 = "0hggyskq9ld1nw9ffqmnbg4fknpklrl29igi4w10asmmbjlr2xa4";
    }
  ) {
    config = pkgs.config;
  };
in
pkgs.mkShell {
  name = "helm-deployments-shell";

  buildInputs = with pkgs; [
    unstable.kubernetes-helm
    unstable.fly
    busybox
    ranger
  ];
}

