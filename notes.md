#Notes on CM4 uConsole

## Wifi disapearing from top bar

```
sudo raspi-config
```
Advanced Options > Network Config > select [dhcpcd] instead of [Network Manager] and reboot.

## Check battery status
```
upower -i /org/freedesktop/UPower/devices/DisplayDevice
```

## Enable 4G Modem

### Run Script to enable modem
```
uconsole-4g-cm4 enable
```
### Check if modem is enabled
```
echo -en "AT+CUSBPIDSWITCH?\r\n" | sudo socat - /dev/ttyUSB2,crnl
```
The output should show '+CUSBPISWITCH: 9001'

### Restart ModemManager
```
sudo systemctl restart ModemManager
```

### Check for modem
```
mmcli -L
```
The output should show 'SIMCOM_SIM7600G'

### Check for primary port
```
mmcli -m any | grep "primary port"
```
The output should show 'primary port: ttyUSB2'

### Continue next steps or open Modem Manager GUI
Enter PIN via GUI

### Send PIN to SIM
```
mmcli -i 0 --pin 'XXXX'
```

### Create network connection
```
sudo nmcli c add type gsm ifname ttyUSB2 con-name 4gnet apn internet
```

### Check if adapter exists
```
sudo ifconfig
```
