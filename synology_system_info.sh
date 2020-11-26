#!/usr/bin/env bash

echo "=== Synology System Info Start ==="
echo
echo $(cat /etc/synoinfo.conf | grep upnpmodelname)
echo $(cat /etc.defaults/VERSION | grep buildnumber)
echo $(cat /etc.defaults/VERSION | grep productversion)
echo
echo "=== Synology System Info End ==="
echo
echo "=== Memory Info Start ==="
echo
echo $(sudo dmidecode --type memory | grep "Manufacturer" | sed -e 's/^[[:space:]]*//')
echo $(sudo dmidecode --type memory | grep "Part Number" | sed -e 's/^[[:space:]]*//')
echo $(sudo dmidecode --type memory | grep "Size" | sed -e 's/^[[:space:]]*//')
echo
echo "=== Memory Info End ==="
echo
echo "=== HDD Info Start ==="
for f in /dev/sata?; do
	echo
  echo $(sudo smartctl -a $f | grep "Vendor")
	echo $(sudo smartctl -a $f | grep "Product")
	echo $(sudo smartctl -a $f | grep "User Capacity")
	echo $(sudo smartctl -a $f | grep "Rotation Rate")
done
echo
echo "=== HDD Info End ==="
