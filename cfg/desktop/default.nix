{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  config = lib.mkIf cfg.desktop.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "pl";

      videoDrivers = (
        if cfg.desktop.flavor == "nvidia"
        then [
          "intel"
          "nvidia"
        ]
        else [
          "modesetting"
          "fbdev"
        ]
      );

      displayManager.gdm = {
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

    # For checking power status
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      networkmanagerapplet # NetworkManager in Gnome
      alacritty # Cool rust terminal
      pavucontrol # PulseAudio Volume Control
      arandr # Front End for xrandr
      brightnessctl # Control screen brightness
    ];
  };
}
