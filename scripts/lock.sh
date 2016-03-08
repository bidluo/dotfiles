#!/bin/bash
# Locks screen and shows lock only on primary monitor
# scrot and imagemagick are required

xset +dpms


LOCKICON=$HOME/dotfiles/images/lock_icon.png
scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png

PX=0
PY=0

# lockscreen image info
R=$(file $LOCKICON  | grep -o '[0-9]* x [0-9]*')
RX=$(echo $R | cut -d' ' -f 1)
RY=$(echo $R | cut -d' ' -f 3)

# Mesuring out for placement in center
RES=$(xrandr --query | grep ' primary' | cut -f4 -d ' ')
SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
PX=$(($SROX + $SRX/2 - $RX/2))
PY=$(($SROY + $SRY/2 - $RY/2))

convert /tmp/screen.png $LOCKICON -geometry +$PX+$PY -composite -matte /tmp/screen.png
 
i3lock -e -u -n -i /tmp/screen.png

xset -dpms
