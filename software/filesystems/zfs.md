# ZFS Configuration

## Note

This information is to recall what commands were used to set up the zpool for mother-brain.

## Devices

- ata-ST4000NT001-3JC101_WX10SD6A -> ../../sdc
- ata-ST4000NT001-3JC101_WX10SD6L -> ../../sdd
- ata-ST4000NT001-3M2101_WX11EFDB -> ../../sda
- ata-ST4000NT001-3M2101_WX11EFG1 -> ../../sdb
- nvme-INTEL_SSDPE21D480GA_PHM2922600D0480BGN -> ../../nvme1n1
- nvme-INTEL_SSDPE21D480GA_PHM2813300JQ480BGN -> ../../nvme2n1

## Pool Creation Command

```bash
sudo zpool create -f \
    -m /srv mother-brain-tank \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O atime=off \
    -O compression=lz4 \
    -O recordsize=64K \
    -O xattr=sa \
    mirror \
        ata-ST4000NT001-3JC101_WX10SD6A \
        ata-ST4000NT001-3JC101_WX10SD6L \
    mirror \
        ata-ST4000NT001-3M2101_WX11EFDB \
        ata-ST4000NT001-3M2101_WX11EFG1 \
    log \
        nvme-INTEL_SSDPE21D480GA_PHM2922600D0480BGN \
        nvme-INTEL_SSDPE21D480GA_PHM2813300JQ480BGN \
&& sudo zfs set mountpoint=legacy mother-brain-tank \
&& sudo zfs create -o mountpoint=legacy mother-brain-tank/configuration \
&& sudo zfs create -o mountpoint=legacy mother-brain-tank/containers \
&& sudo zfs create -o mountpoint=legacy mother-brain-tank/media \
&& sudo zfs create -o mountpoint=legacy mother-brain-tank/virtual-machines \
&& sudo zfs create -o mountpoint=legacy mother-brain-tank/www
```
