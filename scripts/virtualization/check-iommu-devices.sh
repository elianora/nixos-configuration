#!/bin/sh
set -eu

for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d | sort -V); do
  echo "IOMMU Group ${iommu_group##*/}:"
  for device in $(ls -1 "$iommu_group/devices/"); do
    echo -e "\t$(lspci -nns "$device")"
  done
done
