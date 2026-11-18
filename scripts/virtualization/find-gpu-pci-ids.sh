#!/bin/sh
set -eu

lspci -nnk | grep -A 3 -i "VGA\|3D controller"
