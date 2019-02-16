{ pkgs, ... }:

with pkgs.lib;
let
  user = types.submodule {
    options = {
      uid = mkOption {
        type = types.int;
        description = "";
      };
      name = mkOption {
        type = types.string;
        description = "";
      };
      description = mkOption {
        type = types.string;
        description = "";
      };
      group = mkOption {
        type = types.string;
        description = "";
      };
      extraGroups = mkOption {
        type = types.listOf types.string;
        description = "";
      };
    };
  };

  home = types.submodule {
    options = {
      packages = mkOption {
        type = types.listOf types.package;
        description = "";
        default = [];
      };
      sessionVariables = mkOption {
        type = types.attrs;
        description = "";
        default = {};
      };
    };
  };

  xresources = types.submodule {
    options = {
      extraConfig = mkOption {
        type = types.lines;
        description = "";
        default = "";
      };
    };
  };

  programsFirefox = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        description = "";
        default = true;
      };
      enableAdobeFlash = mkOption {
        type = types.bool;
        default = false;
        description = "";
      };
      enableGoogleTalk = mkOption {
        type = types.bool;
        default = false;
        description = "";
      };
      enableIcedTea = mkOption {
        type = types.bool;
        default = false;
        description = "";
      };
    };
  };
  programsGitSigning = types.submodule {
    options = {
      enable = mkOption {
        type = bool;
        description = "";
        default = false;
      };
      key = mkOption {
        type = types.string;
        description = "";
        default = "";
      };
      signByDefault = mkOption {
        type = types.bool;
        description = "";
        default = false;
      };      
    };
  };
  programsGit = types.submodule {
    options = {
      userName = mkOption {
        type = types.string;
        description = "";
      };
      userEmail = mkOption {
        type = types.string;
        description = "";
      };
      signing = mkOption {
        type = programsGitSigning;
        description = "";
      };
      aliases = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "";
      };
    };
  };
  programsVscode = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        description = "";
        default = false;
      };
      extensions = mkOption {
        type = types.listOf types.package;
        description = "";
        default = [];
      };
    };
  };
  programsZshOhMyZshModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        description = "";
        default = false;
      };
      theme = mkOption {
        type = types.str;
        description = "";
        default = "agnoster";
      };
      plugins = mkOption {
        type = types.listOf types.str;
        description = "";
        default = [];
      };
    };
  };
  programsZsh = types.submodule {
    options = {
      initExtra = mkOption {
        type = types.lines;
        description = "";
        default = "";
      };
      shellAliases = mkOption {
        description = "";
        type = types.attrs;
        default = {};
      };
      oh-my-zsh = mkOption {
        type = programsZshOhMyZshModule;
        description = "";
        default = {};
      };
    };
  };

  programs = types.submodule {
    options = {
      firefox = mkOption {
        type = programsFirefox;
        description = "";
      };
      git = mkOption {
        type = programsGit;
        description = "";
      };
      vscode = mkOption {
        type = programsVscode;
        description = "";
      };
      zsh = mkOption {
        type = programsZsh;
        description = "";
      };
    };
  };
in
{
  options.nixosConfig = with pkgs.lib; {
    user = user;
    home = home;
    xresources = xresources;
    programs = programs;

    hostName = mkOption {
      type = types.string;
    };

    hostId = mkOption {
      type = types.string;
    };
  };
}
