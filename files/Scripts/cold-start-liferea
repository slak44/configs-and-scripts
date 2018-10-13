#!/usr/bin/bash
DISPLAY=:0 XAUTHORITY="$HOME/.Xauthority" XDG_RUNTIME_DIR=/run/user/1000 liferea &
sleep 1
DISPLAY=:0 wmctrl -r "Liferea" -b toggle,shaded
