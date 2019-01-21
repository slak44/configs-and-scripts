#!/usr/bin/bash
XDG_RUNTIME_DIR=/run/user/1000 XAUTHORITY="/home/slak/.Xauthority" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus DISPLAY=:0 liferea &
sleep 2
DISPLAY=:0 wmctrl -r "Liferea" -b toggle,shaded
