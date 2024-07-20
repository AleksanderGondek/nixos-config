# This version of desktop environment assumes 
# having 'powerful' workstation with nvidia card
{ config, pkgs, latest-nixpkgs, ... }:

let
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
    meta = { description = "ABCD"; };
  };
in {
  services.xserver = {
    # Enable propriatary drivers
    videoDrivers = [
      "intel" "nvidia"
    ];

    enable = true;
    xkb.layout = "pl";

    displayManager.gdm = {
      wayland = false;
      enable = true;
    };
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        feh
        betterlockscreen
        polybarFull
        rofi
      ];
    };  
  };

  fonts.packages = with pkgs; [
    font-awesome_4
    terminus_font
    powerline-fonts
    (latest-nixpkgs.nerdfonts.override { 
      fonts = ["Hack"]; 
    })
    berkeley-mono
  ];
  
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # NetworkManager in Gnome
    alacritty # Cool rust terminal
    pavucontrol # PulseAudio Volume Control
    arandr # Front End for xrandr
    brightnessctl # Control screen brightness
  ];
}
