#!/usr/bin/env bash

mkdir -p tests
mkdir -p results

ts=$(date +%s)

FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-read.conf --output-format=json+> results/CrystalDiskMark-$ts-read.json
FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-write.conf --output-format=json+> results/CrystalDiskMark-$ts-write.json
FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-mix.conf --output-format=json+> results/CrystalDiskMark-$ts-mix.json

echo "Done."
