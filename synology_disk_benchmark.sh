#!/usr/bin/env bash

# =======================================================================================
#
# A simple script to test Synology NAS disk speed with hdparm, dd and fio.
#
# How to use:
#
# 1. Save synology_disk_benchmark.sh and xfio.conf to your Synology NAS
# 2. Make it executable: chmod +x synology_disk_benchmark.sh
# 3. Run: sudo ./synology_disk_benchmark.sh <test_name>
# 4. A report file <test_name>.md will be created
#
# =======================================================================================

filename=`echo "$1" | tr " " _`
filename="${filename,,}".md

device=`echo "$2" | tr " " _`
if [ -z "$device" ]
then
	echo "Parsing device from command line..."
	volume=`dirname "$PWD"`
	device=`df $volume | tail -1 | awk '{ print $1 }'`
fi

echo "Running with filename=${filename}"
echo "Running with volume=${volume}"
echo "Running with device=${device}"

echo $@
echo $@ > $filename

#########################################################################################

exec () {
	echo; echo ---; echo
	echo "$1"
	echo

	echo --- >> $filename
	echo '```bash' >> $filename
	echo "$1" >> $filename
	echo '```' >> $filename
	echo '```' >> $filename

	eval "$1" 2>&1 | tee -a $filename

	echo '```' >> $filename
}

#########################################################################################

#########################################################################################

read -r -d '' cmd << EOM
sudo hdparm -Tt $device
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# create a 1 GiB test file with random data (it can take minutes)
head -c 1G </dev/urandom >test
# clear cache
sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
# read from test file, read 1 MiB each time, read 1024 times, total read 1 GiB
dd if=test of=/dev/null bs=1M count=1024
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# write 0 to test file, write 1 GiB each time, write 2 times, total write 2 GiB
dd if=/dev/zero of=test bs=1G count=2 oflag=dsync
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# write 0 to test file, write 128 MiB each time, write 8 times, total write 1 GiB
dd if=/dev/zero of=test bs=128M count=8 oflag=dsync
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# write 0 to test file, write 1 MiB each time, write 1024 times, total write 1 GiB
dd if=/dev/zero of=test bs=1M count=1024 oflag=dsync
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# write 0 to test file, write 128 KiB each time, write 1024 times, total write 128 MiB
dd if=/dev/zero of=test bs=128k count=1024 oflag=dsync
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# write 0 to test file, write 4 KiB each time, write 1024 times, total write 4 MiB
dd if=/dev/zero of=test bs=4k count=1024 oflag=dsync
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
# write 0 to test file, write 512 bytes each time, write 1024 times, total write 512 KiB
dd if=/dev/zero of=test bs=512 count=1024 oflag=dsync
EOM

exec "$cmd"

#########################################################################################

read -r -d '' cmd << EOM
fio xfio.conf
EOM

exec "$cmd"

#########################################################################################

rm test
echo
