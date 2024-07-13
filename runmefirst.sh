#!/usr/bin/env bash
if [ -f /mnt/shared/m365setup ]; then
  echo "setup is already complete! if you feel this is reached in error, you can nuke the winapps virt completely by deleting /home/docker/* and deleting /mnt/shared/provisioned and /mnt/shared/m365setup and reboot!"
  echo "you can observe provisioning from http://127.0.0.1:8006"
  sleep 1
  echo "restarting winapps setup"
fi

if ! [ -f /mnt/shared/provisioned ] && ! [ -f /mnt/shared/m365setup ]; then
  echo "provisioning of windows is still in progress, you can check up on it from http://127.0.0.1:8006"
  exit 1
fi

if [ -f /mnt/shared/provisioned ] && ! [ -f /mnt/shared/m365setup ]; then
  echo "provisioning completed, installing m365"
  xfreerdp /d: /cert:ignore /u:celes /p:renata /v:127.0.0.1 +auto-reconnect +home-drive -wallpaper &
    sleep 5
    pkill xfreerdp
    xfreerdp /cert:ignore /d: /u:celes /p:renata /v:127.0.0.1 +auto-reconnect +clipboard +home-drive -wallpaper /scale:140 /dynamic-resolution '/wm-class:M365 Apps Installation' '/app:program:C:\oem\install2.bat'
echo "if it exists with [19:13:18:742] [73363:00011e95] [INFO][com.freerdp.core] - [rdp_print_errinfo]: ERRINFO_LOGOFF_BY_USER (0x0000000C):The disconnection was initiated by the user logging off... We're all set!"
sleep 3
fi
cd pkg
./installer.sh
