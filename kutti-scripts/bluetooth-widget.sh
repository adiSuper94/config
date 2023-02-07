#!/bin/sh

is_on(){
  if [ $(bluetoothctl show | rg "Powered: " | sed 's/\s*Powered:\s*//') = 'yes' ]; then
    echo 1
  else
    echo 0
  fi
}
cmd=$(echo "connect\ndisconnect\npair new device\npower" | rofi -dmenu)
echo $cmd
if [ "connect" = "$cmd" ]; then
  if [ "$(is_on)" = 0 ]; then
    bluetoothctl power on
  fi
  bluetoothctl devices | sed "s/Device //" | rofi -dmenu | sed -E "s/\s.*//" | xargs bluetoothctl connect
elif [ "disconnect" = "$cmd" ]; then
  bluetoothctl disconnect
elif [ "pair new device" = "$cmd" ]; then
  chosen_device=bluetoothctl --timeout 5 scan on | rg "Device " |  sed "s/.*Device //" | rofi -dmenu
  bluetoothctl pair $chosen_device && bluetoothctl trust $chosen_device
elif [ "power" = "$cmd" ]; then
  arg=$(echo "on\noff" | rofi -dmenu)
  bluetoothctl power $arg
else
  echo "how did you even break this"
fi

