#!/run/current-system/sw/bin/sh

main_bar_set=0

# Lauch bar per monitor
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  if [ $main_bar_set == 0 ]
  then
    MONITOR=$m polybar -q -c ~/.config/polybar/config.ini desktop-mainbar > /dev/null 2>&1 &
    main_bar_set=1
  else
    MONITOR=$m polybar -q -c ~/.config/polybar/config.ini desktop-secondarybar > /dev/null 2>&1 &
  fi
done
