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
    cue = pkgs.vimUtils.buildVimPlugin {
      name = "cue-git-2020-05-20";
      src = pkgs.fetchgit {
        url = "https://github.com/jjo/vim-cue.git";
        rev = "9b26fb250d473f949fc90cabe70efff316a90248";
        sha256 = "0aybj1xxi860cn7wzg13z50f16kdsyhba0z7qwchps4fr24xkjms";
      };
      meta = {
        homepage = https://github.com/jjo/vim-cue;
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

  " Map tabs to double space
  set expandtab
  set tabstop=2
  set shiftwidth=2
  map <F2> :retab <CR>

  let NERDTreeShowHidden=1

  " <!-- Python -->
  augroup pythony
    au!
    au BufNewFile,BufRead *.py set tabstop=2
    au BufNewFile,BufRead *.py set softtabstop=2
    au BufNewFile,BufRead *.py set shiftwidth=2
    au BufNewFile,BufRead *.py set textwidth=79
    au BufNewFile,BufRead *.py set expandtab
    au BufNewFile,BufRead *.py set autoindent
    au BufNewFile,BufRead *.py set fileformat=unix
    au BufNewFile,BufRead *.py syntax enable
    au BufNewFile,BufRead *.py set number
    au BufNewFile,BufRead *.py set cursorline
    au BufNewFile,BufRead *.py set showmatch
    au BufNewFile,BufRead *.py let python_highlight_all = 1
  augroup end
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
      "vim-surround"
      "cue"
      "YouCompleteMe"
    ];
  }];
}
