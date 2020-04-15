#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

if [ $(hostname) == "TAG009443491811" ]
then
  # Basically DELL 5540
  # Only this machine is naughty in terms of resolution shenaningans
  if [ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -gt 1 ]
  then
    # Docking station
    /run/current-system/sw/bin/sh ~/.screenlayout/work-laptop-docked.layout.sh
  else
    # Single screen
    /run/current-system/sw/bin/sh ~/.screenlayout/work-laptop.layout.sh
  fi
fi

/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh ~/.config/polybar/run-polybar.sh
