{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  options.agondek-cfg.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, the host machine will be configured to support
        desktop mode (aka. not only terminal console).
      '';
    };
    flavor = lib.mkOption {
      type = lib.types.enum ["default" "nvidia"];
      default = "default";
      description = ''
        What kind of desktop setup should be configured.
      '';
    };
    windowsManager = lib.mkOption {
      type = lib.types.enum ["i3" "hyprland"];
      default = "i3";
    };
  };

  config = lib.mkIf cfg.desktop.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "pl";

      videoDrivers = (
        if cfg.desktop.flavor == "nvidia"
        then [
          "nvidia"
        ]
        else [
          "modesetting"
          "fbdev"
        ]
      );

      displayManager.gdm = {
        enable = true;
        wayland = cfg.desktop.windowsManager == "hyprland";
      };

      windowManager.i3 = {
        enable = cfg.desktop.windowsManager == "i3";
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

    environment.systemPackages = with pkgs;
      [
        networkmanagerapplet # NetworkManager in Gnome
        alacritty # Cool rust terminal
        pavucontrol # PulseAudio Volume Control
        brightnessctl # Control screen brightness
      ]
      ++ (
        if cfg.desktop.windowsManager == "hyprland"
        then [
          hyprlock
          hyprshot
          nwg-displays
          rofi-wayland
          swaybg
          wlogout
        ]
        else [
          arandr # Front End for xrandr
        ]
      );

    programs.hyprland.enable = cfg.desktop.windowsManager == "hyprland";
    programs.waybar.enable = cfg.desktop.windowsManager == "hyprland";
  };
}
