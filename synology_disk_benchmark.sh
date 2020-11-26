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

volume=`dirname "$PWD"`
device=`df $volume | tail -1 | awk '{ print $1 }'`

echo "Running with device=${device}"

./synology_system_info.sh

# test read/cached read timings
sudo hdparm -Tt $device

# create a 1 GiB test file with random data (it can take minutes)
openssl rand -out test $(echo 1G | numfmt --from=iec)

# clear cache
sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

# read from test file, read 1 MiB each time, read 1024 times, total read 1 GiB
dd if=test of=/dev/null bs=1M count=1024

# write 0 to test file, write 1 GiB each time, write 2 times, total write 2 GiB
dd if=/dev/zero of=test bs=1G count=2 oflag=dsync

# write 0 to test file, write 128 MiB each time, write 8 times, total write 1 GiB
dd if=/dev/zero of=test bs=128M count=8 oflag=dsync

# write 0 to test file, write 1 MiB each time, write 1024 times, total write 1 GiB
dd if=/dev/zero of=test bs=1M count=1024 oflag=dsync

# write 0 to test file, write 128 KiB each time, write 1024 times, total write 128 MiB
dd if=/dev/zero of=test bs=128k count=1024 oflag=dsync

# write 0 to test file, write 4 KiB each time, write 1024 times, total write 4 MiB
dd if=/dev/zero of=test bs=4k count=1024 oflag=dsync

# write 0 to test file, write 512 bytes each time, write 1024 times, total write 512 KiB
dd if=/dev/zero of=test bs=512 count=1024 oflag=dsync

fio xfio.conf

rm test
