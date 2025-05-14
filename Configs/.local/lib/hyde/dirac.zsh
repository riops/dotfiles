#!/bin/zsh
STATUS=$((via-cli vpn status | grep 'VPN connection status') | awk -F': *' '{print $2}')

if [ "$STATUS" = "not connected." ] || [ "$STATUS" = "" ]; then
    echo "VPN is not connected, connecting...";
    /home/riops/.scripts/vpn.zsh
fi

SSH_AND_SUDO_PASS=$(pass ssh_password)

sleep 3

# Use expect directly
/usr/bin/expect -c "
spawn ssh -X berk@144.122.30.173
expect \"berk@144.122.30.173's password: \"
send \"$SSH_AND_SUDO_PASS\r\"
interact
"
