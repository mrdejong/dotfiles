xrandr --output HDMI-1 --auto --dpi 144 --primary --right-of eDP-1 --auto &
# xrandr --output eDP-1 --mode 1920x1080 --pos 0x180 --rotate normal --output HDMI-1 --primary --mode 2560x1440 --pos 1920x0 --rotate normal

picom --experimental-backends &
nitrogen --restore &
