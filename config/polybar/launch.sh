#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar1 and bar2
#echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar -q top 2>&1 | tee -a /tmp/polybar1.log & disown
#  polybar -q bottom 2>&1 | tee -a /tmp/polybar1.log & disown
#polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

#if you have tow manitor

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload mybar &
    MONITOR=$m polybar --reload bottom -c ~/.config/polybar/config-bottom-bar.ini &
  done
else
  polybar --reload mybar &
  polybar --reload bottom &
fi

echo "Bars launched..."
