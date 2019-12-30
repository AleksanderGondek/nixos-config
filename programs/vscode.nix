{ config, pkgs, userSecrets, ... }:

let
  preConfiguredVscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "python";
        publisher = "ms-python";
        version = "2019.11.50794";
        sha256 = "1imc4gc3aq5x6prb8fxz70v4l838h22hfq2f8an4mldyragdz7ka";
      }
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.6.3";
        sha256 = "1mc3awybzd2ql1b86inirhsw3j2c7cs0b0nvbjp38jjpq674bmj7";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.3.8";
        sha256 = "17dl10m3ayf57sqgil4mr9fjdm7i8gb5clrs227b768pp2d39ll9";
      }
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "1.1.14";
        sha256 = "1qp1vldfz5hjpz2ws30705rdp7jspg9qhs17hh0lvs4p5fdr1f4g";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "2.6.1";
        sha256 = "1sj1giihmha5x7hh70xqy7anwy3gxbmd3fdx91q1vdcsilzlf3zk";
      }
      {
        name = "latex-support";
        publisher = "torn4dom4n";
        version = "3.1.0";
        sha256 = "1h7jk3bwqrzmjssr4m9spwjy3gh5m6miglllh33h818qx590k9s6";
      }
    ];
  };
in 
preConfiguredVscode
