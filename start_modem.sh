#!/bin/bash

# Enable the 4G modem
echo "Enabling the 4G modem..."
uconsole-4g-cm4 enable
echo "4G modem enabled."

# Restart ModemManager
echo "Restarting ModemManager..."
sudo systemctl restart ModemManager
echo "ModemManager restarted."

# Check the primary port
echo "Checking the primary port..."
mmcli -m any | grep "primary port"

# Prompt for the SIM PIN
read -sp "Enter SIM PIN: " sim_pin
echo

# Unlock the SIM with PIN
echo "Unlocking the SIM with PIN..."
mmcli -i 0 --pin "$sim_pin"
echo "SIM unlocked."

# Add GSM connection
echo "Adding GSM connection..."
sudo nmcli c add type gsm ifname ttyUSB2 con-name 4gnet apn internet
echo "GSM connection added."

# Display network interfaces
echo "Checking network interfaces..."
sudo ifconfig

# Check if ppp0 adapter is present
if ifconfig | grep -q "ppp0"; then
  echo "Modem started correctly. PPP0 adapter is present."
else
  echo "Modem not started correctly. PPP0 adapter is not present."
fi
