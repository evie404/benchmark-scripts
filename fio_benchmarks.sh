#!/usr/bin/env bash

mkdir -p tests
FIO_LOOPS=${FIO_LOOPS:-1} fio xfio.conf --output-format json+> results.json
cat results.json
