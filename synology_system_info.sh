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
mem_info=$(sudo dmidecode --type memory)
echo $(echo -e ${mem_info} | grep "Manufacturer" | sed -e 's/^[[:space:]]*//')
echo $(echo -e ${mem_info} | grep "Part Number" | sed -e 's/^[[:space:]]*//')
echo $(echo -e ${mem_info} | grep "Size" | sed -e 's/^[[:space:]]*//')
echo
echo "=== Memory Info End ==="
echo
echo "=== HDD Info Start ==="
for f in /dev/sata?; do
	echo
	hdd_info=$(sudo smartctl -a $f)
	echo $(echo -e ${hdd_info} | grep "Vendor")
	echo $(echo -e ${hdd_info} | grep "Product")
	echo $(echo -e ${hdd_info} | grep "User Capacity")
	echo $(echo -e ${hdd_info} | grep "Rotation Rate")
done
echo
echo "=== HDD Info End ==="
