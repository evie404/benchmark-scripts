#!/usr/bin/env bash

mkdir -p tests

FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-read.conf --output-format json+> CrystalDiskMark-read.json
FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-write.conf --output-format json+> CrystalDiskMark-write.json
FIO_LOOPS=${FIO_LOOPS:-1} fio CrystalDiskMark-mix.conf --output-format json+> CrystalDiskMark-mix.json

echo "Done."
