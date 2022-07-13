#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

readonly hostname=$(hostname)
if [ "${hostname}" == "blackwood" ]; then
  xrandr --output DP-0.8 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DP-0.1.1 --mode 3840x2160 --pos 3840x0 --rotate normal --output HDMI-0 --off --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --off --output USB-C-0 --off
  /run/current-system/sw/bin/sh -c 'betterlockscreen -u /home/agondek/.config/wallpapers/nix-glow.png -- -r 3840x2160' &
else 
  /run/current-system/sw/bin/sh -c 'betterlockscreen -u /home/agondek/.config/wallpapers/nix-glow.png -- -r 2560x1440' &
fi

/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh ~/.config/polybar/run-polybar.sh
