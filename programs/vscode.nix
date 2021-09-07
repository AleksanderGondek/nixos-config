{ config, pkgs, ... }:

let
  preConfiguredVscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      matklad.rust-analyzer
      golang.Go
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "python";
        publisher = "ms-python";
        version = "2020.12.424452561";
        sha256 = "0zd0wdaip4nd9awr0h0m5afarzwhkfd8n9hzdahwf43sh15lqblf";
      }
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.9.10";
        sha256 = "1afmqzlw3bl9bv59l9b2jrljhbq8djb7vl8rjv58c5wi7nvm2qab";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.5.0";
        sha256 = "0rhdnj8vfpcvy771l6nhh4zxyqspyh84n9p1xp45kq6msw22d7rx";
      }
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "1.1.18";
        sha256 = "0dg68z9h84rpwg82wvk74fw7hyjbsylqkvrd0r94ma9bmqzdvi4x";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.4.0";
        sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
      }
      {
        name = "latex-support";
        publisher = "torn4dom4n";
        version = "3.5.0";
        sha256 = "1sq8z7p1s92cmn7ka03n5nrx2l9y81rzr011qmm5qdrf1vc9whaz";
      }
      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "1.10.2";
        sha256 = "1ll046rf5dyc7294nbxqk5ya56g2bzqnmxyciqpz2w5x7j75rjib";
      }
      {
        name = "vscode-bazel";
        publisher = "BazelBuild";
        version = "0.4.0";
        sha256 = "0p018878pxr7vxr6375fywchzq1xwvxnjrb4zvp444s6p3sknxxg";
      }
      {
        name = "cuelang";
        publisher = "nickgo";
        version = "0.0.1";
        sha256 = "1wk953s7vgjzvgs3s5vkziiccl67pz7bmf9pkyvfljhl4kaia0vl";
      }
      {
        name = "dhall-lang";
        publisher = "dhall";
        version = "0.0.4";
        sha256 = "7vYQ3To2hIismo9IQWRWwKsu4lXZUh0Or89WDLMmQGk=";
      }
      {
        name = "vscode-dhall-lsp-server";
        publisher = "dhall";
        version = "0.0.4";
        sha256 = "WopWzMCtiiLrx3pHNiDMZYFdjS359vu3T+6uI5A+Nv4=";
      }
    ];
  };
in 
preConfiguredVscode
