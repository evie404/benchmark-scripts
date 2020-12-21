#!/usr/bin/env bash

function meminfo {
	mem_info_tmp_file=$(mktemp)
	sudo dmidecode --type memory >${mem_info_tmp_file}
	cat ${mem_info_tmp_file} | grep "Manufacturer" | sed -e 's/^[[:space:]]*//'
	cat ${mem_info_tmp_file} | grep "Part Number" | sed -e 's/^[[:space:]]*//'
	cat ${mem_info_tmp_file} | grep "Size" | sed -e 's/^[[:space:]]*//'
}

echo "=== Synology System Info Start ==="
echo
cat /etc/synoinfo.conf | grep upnpmodelname
cat /etc.defaults/VERSION | grep buildnumber
cat /etc.defaults/VERSION | grep productversion
echo
echo "=== Synology System Info End ==="
echo
echo "=== Memory Info Start ==="
echo
cat /proc/meminfo | grep MemTotal
command -v dmidecode >/dev/null && meminfo || echo "dmidecode not found. skipping detailed memory info"
echo
echo "=== Memory Info End ==="
echo
echo "=== HDD Info Start ==="
for f in /dev/sata?; do
	echo
	hdd_info_tmp_file=$(mktemp)
	sudo smartctl -a ${f} >${hdd_info_tmp_file}
	cat ${hdd_info_tmp_file} | grep "Vendor"
	cat ${hdd_info_tmp_file} | grep "Product"
	cat ${hdd_info_tmp_file} | grep "User Capacity"
	cat ${hdd_info_tmp_file} | grep "Rotation Rate"
done
for f in /dev/sdb*; do
	echo
	hdd_info_tmp_file=$(mktemp)
	sudo smartctl -a ${f} >${hdd_info_tmp_file}
	cat ${hdd_info_tmp_file} | grep "Vendor"
	cat ${hdd_info_tmp_file} | grep "Product"
	cat ${hdd_info_tmp_file} | grep "User Capacity"
	cat ${hdd_info_tmp_file} | grep "Rotation Rate"
done
echo
echo "=== HDD Info End ==="
echo
echo "=== RAID Info Start ==="
echo
cat /proc/mdstat
echo
echo "=== RAID Info End ==="
echo
echo "=== Partiton Info Start ==="
echo
df -Th
echo
echo "=== Partiton Info End ==="
