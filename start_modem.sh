#!/bin/bash

set -x  # Enable script debugging

# Enable the 4G modem
uconsole-4g-cm4 enable

# Wait for the modem to initialize
MODEM_READY=0
RETRIES=10  # Number of retries
DELAY=1  # Delay in seconds
COUNTER=0

while [[ $COUNTER -lt $RETRIES ]]; do
    if mmcli -L | grep -q "Modem"; then
        MODEM_READY=1
        break
    fi
    sleep $DELAY
    COUNTER=$((COUNTER+1))
done

if [[ $MODEM_READY -eq 0 ]]; then
    echo "Modem not found after waiting. Initialization failed."
    exit 1
fi

# Restart ModemManager service
sudo systemctl restart ModemManager

# Get the primary port
PRIMARY_PORT=$(mmcli -m any | grep "primary port" | awk '{print $4}')
echo "Primary port: $PRIMARY_PORT"  # Debug statement

# Check if PRIMARY_PORT is not empty
if [[ -n "$PRIMARY_PORT" ]]; then
    echo "Primary port found: $PRIMARY_PORT"
    # Unlock the SIM card
    mmcli -i 0 --pin '9633'
    
    # Add GSM connection
    sudo nmcli c add type gsm ifname $PRIMARY_PORT con-name 4gnet apn internet
    
    # Check if ppp0 adapter is present
    if ifconfig | grep -q "ppp0"; then
        echo "Modem started correctly, ppp0 adapter found."
    else
        echo "Modem failed to start, ppp0 adapter not found."
    fi
else
    echo "Primary port not found. Modem initialization failed."
fi

set +x  # Disable script debugging
