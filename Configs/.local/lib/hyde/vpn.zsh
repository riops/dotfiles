#!/bin/zsh
# if the option is -d, then we want to disconnect
if [[ $1 == "-d" ]]; then
    via-cli vpn disconnect
    exit 0
fi
# Use expect for the sudo command
~/.scripts/via-vpn-srv-wrapper
# Start the VPN session 
# Assuming that starting a session doesn't need any interaction.
# Maybe expect can be used here too.
sleep 3
via-cli session start
~/.scripts/via-cli-wrapper
