#!/usr/bin/env bash

echo "Synology System Info:"
echo $(cat /etc/synoinfo.conf | grep upnpmodelname)
echo $(cat /etc.defaults/VERSION | grep buildnumber)
echo $(cat /etc.defaults/VERSION | grep productversion)
echo
echo "Memory Info:"
echo $(sudo dmidecode --type memory | grep "Manufacturer" | sed -e 's/^[[:space:]]*//')
echo $(sudo dmidecode --type memory | grep "Part Number" | sed -e 's/^[[:space:]]*//')
echo $(sudo dmidecode --type memory | grep "Size" | sed -e 's/^[[:space:]]*//')
echo
echo "HDD Info:"
for f in /dev/sata?; do
  echo $(sudo smartctl -a $f | grep "Vendor")
	echo $(sudo smartctl -a $f | grep "Product")
	echo $(sudo smartctl -a $f | grep "User Capacity")
	echo $(sudo smartctl -a $f | grep "Rotation Rate")
done
