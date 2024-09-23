#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo "%{F#66dedede}Bluetooth"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo "Bluetooth"
  fi
  echo "%{F#dedede}Bluetooth"
fi
