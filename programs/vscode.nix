{ config, pkgs, ... }:

let
  preConfiguredVscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "python";
        publisher = "ms-python";
        version = "2020.5.86806";
        sha256 = "0j3333gppvnn2igw77cbzpsgw6lbkb44l4w7rnpzn9z0q3piy6d4";
        #version = "2020.2.64397";
        #sha256 = "1kwyc5ycz1276i2zbw93mpq59y2py6kj71gvhzya8xvm184jk07a";
      }
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.9.0";
        sha256 = "0p2wbnw98zmjbfiz4mi1mh131s78r01kjnja339lwdigqxg88gi6";
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
        version = "1.1.17";
        sha256 = "0ys8bv74pi8ss5izyjsl0ipvi95qljw67fs26zg2dn90izcph8d8";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.0.0";
        sha256 = "0n2j2wf25az8f1psss8p9wkkbk3s630pw24qv54fv97sgxisn5r3";
      }
      {
        name = "latex-support";
        publisher = "torn4dom4n";
        version = "3.2.0";
        sha256 = "02kr7acvl8cv9746a3kbhbc85jl6zbk7daw45k6zppls8lklglhc";
      }
      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "1.9.0";
        sha256 = "0ic0zbv4pja5k4hlixmi6mikk8nzwr8l5w2jigdwx9hc4zhkf713";
      }
      {
        name = "vscode-bazel";
        publisher = "BazelBuild";
        version = "0.3.0";
        sha256 = "0rlja1hn2n6fyq673qskz2a69rz8b0i5g5flyxm5sfi8bcz8ms05";
      }
      {
        name = "rust";
        publisher = "rust-lang";
        version = "0.7.8";
        sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
      }
    ];
  };
in 
preConfiguredVscode
