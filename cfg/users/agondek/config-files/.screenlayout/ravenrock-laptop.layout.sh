#!/run/current-system/sw/bin/sh

readonly monitor_count=$(xrandr -q | grep ' connected' | wc -l)

if [ "${monitor_count}" == "2" ]; then
  xrandr --output eDP-1 --primary --mode 2560x1440 --pos 0x1440 --rotate normal --output DP-1 --off --output HDMI-1 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-2 --off
else 
  xrandr --output eDP-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off
fi
