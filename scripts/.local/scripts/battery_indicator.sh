#!/usr/bin/env bash

#output="$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)"
percentage="$(cat /sys/class/power_supply/BAT1/capacity)"
status="$(cat /sys/class/power_supply/BAT1/status)"
symbol=""

if [[ ($status == "Discharging") && ($percentage > 80) ]]; then
    symbol=""
elif [[ ($status == "Discharging") && ($percentage > 60) ]]; then
    symbol=""
elif [[ ($status == "Discharging") && ($percentage > 40) ]]; then
    symbol=""
elif [[ ($status == "Discharging") && ($percentage > 20) ]]; then
    symbol=""
elif [[ $status == "Discharging" ]]; then
    symbol=""
else
    symbol=""
fi

echo " ${percentage}% ${symbol} "
