#!/bin/zsh

##############################################################################
# CONFIGURATION
##############################################################################
CREDS_FILE="/tmp/truba_openvpn_creds"
LOG_FILE="/tmp/truba_openvpn.log"
OVPN_CONFIG="/home/riops/.scripts/required_files/TRUBA-genel.ovpn"

##############################################################################
# DISCONNECT FUNCTION
##############################################################################
disconnect_vpn() {
    echo "Checking for Tübitak (OpenVPN) process..."
    # If a process contains our .ovpn config in its command line, kill it
    if pgrep -f "$OVPN_CONFIG" >/dev/null 2>&1; then
        echo "Disconnecting Tübitak (OpenVPN)..."
        sudo pkill -f "$OVPN_CONFIG"
    else
        echo "Tübitak is not running."
    fi

    # Clean up credentials file if it exists
    if [[ -f $CREDS_FILE ]]; then
        echo "Removing credentials file..."
        sudo shred -u "$CREDS_FILE" 2>/dev/null
    fi

    echo "Disconnecting VIA..."
    via-cli vpn disconnect 2>/dev/null || true
}

##############################################################################
# CONNECT TUBITAK (OPENVPN) IN BACKGROUND
##############################################################################
connect_tubitak() {
    echo "Connecting to Tübitak (OpenVPN) in the background..."

    # 1. Retrieve password from pass
    PASSWORD="$(pass truba_pass)"

    # 2. Write out the credentials to a root-owned file
    sudo bash -c "echo 'beozcan' > '$CREDS_FILE'"
    sudo bash -c "echo '$PASSWORD' >> '$CREDS_FILE'"

    # 3. Launch OpenVPN as a daemon
    sudo openvpn \
      --config "$OVPN_CONFIG" \
      --auth-user-pass "$CREDS_FILE" \
      --daemon \
      --log "$LOG_FILE"

    echo "OpenVPN started in the background."
    echo "Logs: $LOG_FILE"
}

##############################################################################
# CONNECT VIA
##############################################################################
connect_via() {
    echo "Connecting to VIA..."

    # 1. Use your wrapper that handles any expect-based login
    ~/.scripts/via-vpn-srv-wrapper

    # 2. Wait briefly
    sleep 3

    # 3. Start the VIA session
    via-cli session start

    # 4. Possibly another wrapper script
    ~/.scripts/via-cli-wrapper
}

##############################################################################
# MAIN LOGIC
##############################################################################
if [[ $1 == "-d" ]]; then
    disconnect_vpn
    exit 0
fi

case "$1" in
  # If user typed "vpn tubitak"
  tubitak)
    connect_tubitak
    ;;

  # If user typed "vpn via"
  via)
    connect_via
    ;;

  # If no arguments given, prompt user
  "")
    echo "Which VPN would you like to connect to?"
    echo "1) Tübitak (OpenVPN)"
    echo "2) VIA"
    echo -n "Enter 1 or 2: "
    read -k 1 choice
    echo

    case "$choice" in
      1) connect_tubitak ;;
      2) connect_via ;;
      *) echo "Invalid choice."; exit 1 ;;
    esac
    ;;

  # Anything else is invalid usage
  *)
    echo "Invalid argument: $1"
    echo "Usage: vpn         (prompt for Tübitak/VIA)"
    echo "       vpn tubitak (connect immediately to Tübitak)"
    echo "       vpn via     (connect immediately to VIA)"
    echo "       vpn -d      (disconnect both, if running)"
    exit 1
    ;;
esac
