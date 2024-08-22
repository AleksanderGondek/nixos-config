{
  pkgs,
  lib,
  ...
}: let
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
in
  with pkgs;
    buildVimPlugin {
      pname = "komau.vim";
      version = "f0372e7";
      src = fetchFromGitHub {
        owner = "ntk148v";
        repo = "komau.vim";
        rev = "f0372e7336139ad3c21088240a2ec18162f21595";
        sha256 = "r8+aWbx94DQjkWYQBGochkv6v0NbzFiZq6cg/GPX/YY=";
      };
      meta.homepage = "https://github.com/ntk148v/komau.vim";
    }
