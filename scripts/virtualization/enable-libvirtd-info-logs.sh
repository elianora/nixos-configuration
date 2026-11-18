#!/bin/sh
set -eu

sudo virt-admin -c libvirtd:///system daemon-log-outputs "3:journald 2:file:/var/log/libvirt/libvirtd.log"
sudo virt-admin -c libvirtd:///system daemon-log-filters "3:remote 4:event 3:util.json 3:util.object 3:util.dbus 3:util.netlink 3:node_device 3:rpc 3:access 2:*"
sudo virt-admin -c libvirtd:///system daemon-timeout --timeout 0
