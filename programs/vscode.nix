{ config, pkgs, userSecrets, ... }:

let
  preConfiguredVscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "python";
        publisher = "ms-python";
        version = "2020.2.63072";
        sha256 = "12v79256h3vl8a4dfv29x7m8w2g3jh4k5rhpxvll8z5hzbv3lypf";
      }
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.7.8";
        sha256 = "0bl0j1inzrg9ylil5lb79q26j34gfy023xcv04ycrjsjkhlslpqc";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.3.9";
        sha256 = "0l6zrpp2klqdym977zygmbzf0478lbqmivcxa2xmqyi34c9vwli7";
      }
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "1.1.15";
        sha256 = "0b5785m2zbvyhs7s4y4cqvi6rsvg4xq9qpci7hh6w671hdhgwlfk";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "2.7.0";
        sha256 = "1hrxw4ilm2r48kd442j2i7ar43w463612bx569pdhz80mapr1z9k";
      }
      {
        name = "latex-support";
        publisher = "torn4dom4n";
        version = "3.1.0";
        sha256 = "1h7jk3bwqrzmjssr4m9spwjy3gh5m6miglllh33h818qx590k9s6";
      }
      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "1.7.24";
        sha256 = "09iv72k045w88ycqbmgirxn27a4fbd28skp7gyz9a6aing6rm3kj";
      }
    ];
  };
in 
preConfiguredVscode
