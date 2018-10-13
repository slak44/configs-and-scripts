#!/bin/bash

servDir=$([ $1 ] && echo "$1" || echo "/mnt/data/mc-vanilla-server")
cd "$servDir" || exit "Can't cd to server dir"
java -Xmx4096M -Xms1024M -jar "$servDir/minecraft_server.1.12.jar" "${@:2}"
