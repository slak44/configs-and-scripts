#!/bin/bash
chgrp hwmon-admins /sys/class/hwmon
chgrp hwmon-admins /sys/class/hwmon/*
chgrp hwmon-admins /sys/class/hwmon/*/*
chmod 774 /sys/class/hwmon
chmod 774 /sys/class/hwmon/*
chmod 774 /sys/class/hwmon/*/*

