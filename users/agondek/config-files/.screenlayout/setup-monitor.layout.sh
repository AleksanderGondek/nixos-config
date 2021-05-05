#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

if [ $(hostname) == "ravenrock" ]
then
  /run/current-system/sw/bin/sh ~/.screenlayout/ravenrock-laptop.layout.sh
fi

/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh ~/.config/polybar/run-polybar.sh
