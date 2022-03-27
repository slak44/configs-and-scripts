#!/bin/bash

if [ -f /etc/systemd/sleep.conf ]; then
    sudo mv /etc/systemd/sleep.conf /etc/systemd/sleep.conf.bak
fi
sudo cp /home/slak/Scripts/hibernate-mode-reboot.conf /etc/systemd/sleep.conf


