#!/bin/sh

profile=$(powerprofilesctl list | rg "\s[a-z-]+:" | sed "s/:.*//" | sed "s/*//" | sed "s/\s*//" | rofi -dmenu)
powerprofilesctl set $profile
powerprofilesctl list
