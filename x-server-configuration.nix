{ lib, config, pkgs, ... }:

{
  # Install required packages
  environment.systemPackages = with pkgs; [
    rxvt_unicode
    screenfetch
  ];

  # xfce + i3-gaps + rxvt
  services.xserver = {
    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    enable = true;
    
    # Touchpad
    libinput.enable = true;

    # Trackpad
    synaptics.enable = true;

    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      default = "i3";
    };
  };

  # I3 tries to load terminals in certain order,
  # urxvtd is high up on the priority list
  # so it suffices to start the deamon 
  systemd.user.services."urxvtd" = {
    enable = true;
    description = "rxvt unicode daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
  };
}
