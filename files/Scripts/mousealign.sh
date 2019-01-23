#!/bin/bash
mouseId=$(xinput | grep -E "^⎜.*?USB Gaming Mouse\s\s" | head -n1 | cut -f 2 | cut -d= -f2)
# Disable mouse acceleration
xinput set-prop $mouseId "libinput Accel Profile Enabled" 0, 1
xinput set-prop $mouseId "libinput Accel Speed" 0
# Default speed, let mouse deal with it
xinput set-prop $mouseId "libinput Accel Speed" 0
