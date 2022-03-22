#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

/run/current-system/sw/bin/sh -c 'betterlockscreen -u /home/agondek/.config/wallpapers/nix-glow.png -- -r 2560x1440' &
/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh ~/.config/polybar/run-polybar.sh
