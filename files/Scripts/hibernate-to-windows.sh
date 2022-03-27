#!/bin/bash

sudo /home/slak/Scripts/hibernate-mode-reboot
sudo efibootmgr --bootnext 0000
sudo systemctl hibernate

