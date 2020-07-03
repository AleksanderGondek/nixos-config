{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "pl";

    displayManager.gdm = {
      enable = true;
    };
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        feh
        i3lock
        polybarFull
        rofi
      ];
    };  
  };

  fonts.fonts = with pkgs; [
    font-awesome_4
    terminus_font
    powerline-fonts
    (unstable.nerdfonts.override { 
      fonts = ["Hack"]; 
    })
  ];
  
  # For checking power status
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet # NetworkManager in Gnome
    alacritty # Cool rust terminal
    pavucontrol # PulseAudio Volume Control
    arandr # Front End for xrandr
    brightnessctl # Control screen brightness
  ];
}
