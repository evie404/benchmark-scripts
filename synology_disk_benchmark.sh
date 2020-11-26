#!/usr/bin/env bash

# =======================================================================================
#
# A simple script to test Synology NAS disk speed with hdparm, dd and fio.
#
# How to use:
#
# sudo ./synology_disk_benchmark.sh
#
# =======================================================================================

# get the device of the current volume
volume=$(dirname "$PWD")
device=$(df $volume | tail -1 | awk '{ print $1 }')

echo "Running with device=${device}"
echo "Script version: $(git rev-parse HEAD)"
echo "hdparm version: $(hdparm -V)"
echo "dd version: $(dd --version | grep dd)"
echo "fio version: $(fio --version)"

./synology_system_info.sh

echo

function clear_cache {
	sync
	echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null
}

# runs a command 5 times with cache cleared
# example: `5times echo hi`
function 5times {
	clear_cache

	for i in {1..5}
		do $*
	done
}

function dd_read_tests {
	# read from test file, read 1 MiB each time, read 1024 times, total read 1 GiB
	5times dd if=test of=/dev/null bs=1M count=1024
}

function dd_write_tests {
	# write 0 to test file, write 1 GiB each time, write 2 times, total write 2 GiB
	5times dd if=/dev/zero of=test bs=1G count=2 oflag=dsync

	echo

	# write 0 to test file, write 128 MiB each time, write 8 times, total write 1 GiB
	5times dd if=/dev/zero of=test bs=128M count=8 oflag=dsync

	echo

	# write 0 to test file, write 1 MiB each time, write 1024 times, total write 1 GiB
	5times dd if=/dev/zero of=test bs=1M count=1024 oflag=dsync

	echo

	# write 0 to test file, write 128 KiB each time, write 1024 times, total write 128 MiB
	5times dd if=/dev/zero of=test bs=128k count=1024 oflag=dsync

	echo

	# write 0 to test file, write 4 KiB each time, write 1024 times, total write 4 MiB
	5times dd if=/dev/zero of=test bs=4k count=1024 oflag=dsync

	echo

	# write 0 to test file, write 512 bytes each time, write 1024 times, total write 512 KiB
	5times dd if=/dev/zero of=test bs=512 count=1024 oflag=dsync
}

function hdparm_read_timings {
	# test read/cached read timings
	5times sudo hdparm -Tt $device
}

hdparm_read_timings

echo

# create a 1 GiB test file with random data (it can take minutes)
time openssl rand -out test $(echo 1G | numfmt --from=iec)

echo

dd_read_tests

echo

dd_write_tests

echo

clear_cache

# run fio tests
fio xfio.conf

rm test
