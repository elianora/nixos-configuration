#!/bin/sh
set -eu
sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
