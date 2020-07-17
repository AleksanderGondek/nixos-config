  
  { config, pkgs, ... }:

{
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  services.xserver = {
    videoDrivers = [
      "intel" "nvidia"
    ];
  };

  environment.systemPackages = with pkgs; [
    steam
  ];
}
