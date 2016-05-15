#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

if grep -vq London /etc/timezone ; then
    echo "Europe/London" > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
fi

for pkg in git vim tmux silversearcher-ag zip bcmwl-kernel-source build-essential childsplay tuxmath tuxpuck tuxtype tuxpaint; do
    dpkg-query -l $pkg 2> /dev/null | grep -qE '^ii' || apt-get install -y $pkg
done

