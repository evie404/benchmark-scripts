#!/usr/bin/env bash

mkdir -p tests
mkdir -p results

ts=$(date +%s)

FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-read.conf --max-jobs=32 --output-format=json+> results/CrystalDiskMark-$ts-read.json
FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-write.conf --max-jobs=32 --output-format=json+> results/CrystalDiskMark-$ts-write.json
FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-mix.conf --max-jobs=32 --output-format=json+> results/CrystalDiskMark-$ts-mix.json

echo "Done."
