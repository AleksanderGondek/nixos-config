# This version of desktop environment assumes 
# having 'powerful' workstation with nvidia card
{ config, pkgs, ... }:

{
  services.xserver = {
    # Enable propriatary drivers
    videoDrivers = [
      "intel" "nvidia"
    ];

    enable = true;
    layout = "pl";

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
  ];
  
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # NetworkManager in Gnome
    alacritty # Cool rust terminal
  ];
}
