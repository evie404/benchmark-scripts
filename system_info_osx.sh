#!/usr/bin/env bash

system_profiler SPParallelATADataType SPParallelSCSIDataType SPSerialATADataType SPNVMeDataType SPHardwareDataType SPSoftwareDataType -detailLevel mini -json
diskutil list
df
