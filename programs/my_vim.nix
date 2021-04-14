{ config, pkgs, ... }:
# Config inspired by https://github.com/wagnerf42/nixos-config/blob/master/config/my_vim.nix

let
  my_configurable_vim = pkgs.vim_configurable.override {
    python = pkgs.python39Full;
  };
  customPlugins = {
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
in my_configurable_vim.customize {
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

  " Grepper
  let g:grepper = {}
  let g:grepper.tools = ['git', 'rg']

  " YouCompleteMe
  let g:ycm_confirm_extra_conf=0
  let g:ycm_language_server=
\ [
\   {
\     'name': 'rust',
\     'cmdline': ['rust-analyzer'],
\     'filetypes': ['rust'],
\     'project_root_files': ['Cargo.toml']
\   }
\ ]

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

  set backspace=indent,eol,start
 '';

  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // customPlugins;
  vimrcConfig.vam.pluginDictionaries = [{
    names = [
      "molokai"
      "vim-airline"
      "vim-airline-themes"
      "vim-devicons"
      "nerdtree"
      "fzf-vim"
      "vim-grepper"
      "vim-surround"
      "vim-nix"
      "cue"
      "YouCompleteMe"
    ];
  }];
}
