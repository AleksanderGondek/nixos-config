{ config, pkgs, ... }:
# Config inspired by https://github.com/wagnerf42/nixos-config/blob/master/config/my_vim.nix

let
  customPlugins = {
  };
in pkgs.vim_configurable.customize {
  name = "vim";

  vimrcConfig.customRC = ''
 '';

  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // customPlugins;
  vimrcConfig.vam.pluginDictionaries = [{
    names = [
      "vim-devicons"
      "nerdtree"
    ];
  }];
}
