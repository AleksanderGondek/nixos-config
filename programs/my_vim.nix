{ config, pkgs, ... }:
# Config inspired by https://github.com/wagnerf42/nixos-config/blob/master/config/my_vim.nix

let
  customPlugins = {
    semantic-highlight = pkgs.vimUtils.buildVimPlugin {
      name = "semantic-highlight-git-2019-09-01";
      src = pkgs.fetchgit {
        url = "https://github.com/jaxbot/semantic-highlight.vim.git";
        rev = "7cf0aabbd0f9cb531b0045ac2148dff1131616de";
        sha256 = "16dnqrdpxf6322az1rn67ay2a4clqz410xn6zqzr1w2y6x4yly1a";
      };
      meta = {
        homepage = https://github.com/jaxbot/semantic-highlight.vim;
        maintainers = [ pkgs.stdenv.lib.maintainers.jagajaga ];
      };
    };
  };
in pkgs.vim_configurable.customize {
  name = "vim";

  vimrcConfig.customRC = ''
  set encoding=utf-8  " The encoding displayed.
  set fileencoding=utf-8  " The encoding written to file.
  
  let g:molokai_original = 1
  let g:airline_theme='molokai'
  colorscheme molokai
 '';

  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // customPlugins;
  vimrcConfig.vam.pluginDictionaries = [{
    names = [
      "molokai"
      "semantic-highlight"
      "vim-airline"
      "vim-airline-themes"
      "vim-devicons"
      "nerdtree"
      "fzf-vim"
    ];
  }];
}
