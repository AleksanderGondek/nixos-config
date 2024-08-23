{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
  berkeley-mono = pkgs.stdenvNoCC.mkDerivation {
    name = "berkeley-mono-font";
    dontConfigue = true;
    src = builtins.fetchGit {
      url = "ssh://git@github.com/AleksanderGondek/font-berkeley-mono.git";
      rev = "2e884a6c47d29bd246e78f06830718f86cd18c26";
      ref = "master";
    };
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/berkeley-mono/OTF/* $out/share/fonts/opentype/
    '';
    meta = {description = "ABCD";};
  };
in {
  imports = [];

  options.agondek-cfg.fonts = {
    useBerkeleyMono = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If enabled, berkeley-mono font will be installed.
      '';
    };
  };

  config = {
    fonts.packages = with pkgs;
      [
        (pkgs.nerdfonts.override {
          fonts = ["Hack"];
        })
      ]
      ++ (
        if cfg.fonts.useBerkeleyMono
        then [berkeley-mono]
        else []
      );
  };
}
