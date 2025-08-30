if [ $(cat /sys/class/leds/dell::kbd_backlight/brightness) = 1 ]; then
  echo "0" | sudo tee /sys/class/leds/dell::kbd_backlight/brightness
else
  echo "1" | sudo tee /sys/class/leds/dell::kbd_backlight/brightness
fi
