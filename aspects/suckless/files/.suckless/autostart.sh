sh $HOME/.screenlayout/home.sh

dwmblocks &
nitrogen --restore &
picom --experimental-backends --config $HOME/.config/picom/picom.conf &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
