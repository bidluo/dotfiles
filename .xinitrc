xrandr --output HDMI2 --auto --primary
xrandr --output VGA1 --auto --right-of HDMI2 

xrdb -merge ~/.Xresources 

exec i3
exec pulseaudio --start
