#!/usr/bin/env bash

mkdir -p tests
mkdir -p results

ts=$(date +%s)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FIO_IOENGINE=libaio
elif [[ "$OSTYPE" == "darwin"* ]]; then
  FIO_IOENGINE=posixaio
else
  FIO_IOENGINE=psync
fi

FIO_LOOPS=${FIO_LOOPS:-1} FIO_IOENGINE=${FIO_IOENGINE} fio CrystalDiskMark-read.conf --max-jobs=32 --output-format=json+> results/CrystalDiskMark-$ts-read.json
FIO_LOOPS=${FIO_LOOPS:-1} FIO_IOENGINE=${FIO_IOENGINE} fio CrystalDiskMark-write.conf --max-jobs=32 --output-format=json+> results/CrystalDiskMark-$ts-write.json
FIO_LOOPS=${FIO_LOOPS:-1} FIO_IOENGINE=${FIO_IOENGINE} fio CrystalDiskMark-mix.conf --max-jobs=32 --output-format=json+> results/CrystalDiskMark-$ts-mix.json

echo "Done."
