{ config, pkgs, ... }:

{
  # TODO: Change to 'false'
  users.mutableUsers = true;

  users.extraUsers.nix = {
    uid = 1001;
    description = "Nix 'admin' user";

    group = "nix";
    extraGroups = [
      "audio"
      "disk"
      "networkmanager"
      "systemd-journal"
      "video"
      "wheel"
    ];

    createHome = true;
    home = "/home/nix";
  };

  users.extraUsers."${config.nixosConfig.user.name}" = {
    uid = config.nixosConfig.user.uid;
    description = config.nixosConfig.user.description;
    
    group = config.nixosConfig.user.group;
    extraGroups = config.nixosConfig.user.extraGroups;

    createHome = true;
    isNormalUser = true;
    home = "/home/${config.nixosConfig.user.name}";
  };

  home-manager.users."${config.nixosConfig.user.name}" = {
    home.packages = config.nixosConfig.home.packages;
    home.sessionVariables = config.nixosConfig.home.sessionVariables;

    xresources.extraConfig = config.nixosConfig.xresources.extraConfig;

    programs.firefox = {
      enable = config.nixosConfig.programs.firefox.enable;
      enableAdobeFlash = config.nixosConfig.programs.firefox.enableAdobeFlash;
      enableGoogleTalk  = config.nixosConfig.programs.firefox.enableGoogleTalk;
      enableIcedTea = config.nixosConfig.programs.firefox.enableIcedTea;
    };

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      userName = config.nixosConfig.programs.git.userName;
      userEmail  = config.nixosConfig.programs.git.userEmail;

      lfs = {
        enable = true;
      };

      signing = (
        if config.nixosConfig.programs.git.signing.enable == false
        then
          null
        else
          {
            key = config.nixosConfig.programs.git.signing.key;
            signByDefault = config.nixosConfig.programs.git.signing.signByDefault;
            gpgPath = "${pkgs.gnupg}/bin/gpg2";
          }
      );

      aliases = config.nixosConfig.programs.git.aliases;
    };

    programs.vscode = {
      enable = config.nixosConfig.programs.vscode.enable;
      extensions = config.nixosConfig.programs.vscode.extensions;
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      
      initExtra = config.nixosConfig.programs.zsh.initExtra;
      shellAliases = config.nixosConfig.programs.zsh.shellAliases;

      oh-my-zsh = {
        enable = config.nixosConfig.programs.zsh.oh-my-zsh.enable;
        theme = config.nixosConfig.programs.zsh.oh-my-zsh.theme;
        plugins = config.nixosConfig.programs.zsh.oh-my-zsh.plugins;
      };
    };
  };

  nix.trustedUsers = [ "nix" "root" "${config.nixosConfig.user.name}" ];
}
