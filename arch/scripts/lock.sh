#!/bin/bash
# Locks screen and shows lock only on primary monitor
# scrot and imagemagick are required

scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png

i3lock -e -u -n -i /tmp/screen.png
