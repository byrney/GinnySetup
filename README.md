Lubuntu (2015) on the Compaq Mini (2008)
========================================


Installed Lubuntu Trusty on my old Compaq Mini  (HP Mini) and everything works.

Install unetbootin on another machine

    brew cask install unetbootin

    
Plug in a 1Gb USB stick, start the app and choose Lubuntu live (I went for 14.04 the LTS release).

When it's done eject the stick and plug it into the mini,

Reboot and hammer the F8 key while it comes up.  The Lubuntu logo should appear and drop you into the live Desktop.

At this point wifi was not working so I plugged in a network cable and downloaded the drivers

    sudo apt-get update
    sudo apt-get --reinstall install bcmwl-kernel-source

these are the broadcom drivers. The b43 open source ones were not reliable.


Then unplug the cable and see if wifi will connect.  It did, so nice.

Under the start menu there's an option to install so I chose it and elected to wipe the old Ubuntu netbook remix (along with all the data on the disk).

A few config questions and a short wait later I had Lubuntu installed.  I had to repeat the wifi fix and then pretty much everything worked,

* Ethernet
* Wifi
* Suspend
* Suspend when you close the lid
* Trackpad with touch to click and scroll on the RHS


Perfect (if you don't need RAM or CPU or a decent size screen).


Install Xenial (16)
==============

As above but after the install the reboot got stuck. Switch to another console with C-A-F1 and type

    sudo service lightdm stop
    
    
this will stop the screen switching back to the startup.  Then install the correct x video drivers

    sudo apt-get install xserver-xorg-video-intel
    
and restart lightdm

    sudo service lightdm start
    
proceed as usual.




Provisioning the Mini
=====================

install the chef omnitruck

    curl -L https://omnitruck.chef.io/install.sh | sudo bash

This seems to be the lightest chef install. All the apt-get variants want to install chef server.

Install berkshelf

    sudo /opt/chef/embedded/bin/gem install berkshelf --no-rdoc
    
Add it to your path

    [[ $PATH =~ /opt/chef/embedded/bin ]] || export PATH="$PATH:/opt/chef/embedded/bin
    
Then for serverless provisioning you need to create a chef config, a Berksfile and a node.json

    mkdir ~/Setup
    cd ~/Setup
    mkdir .cache

    # create the berksfile
    echo '
    source "https://supermarket.chef.io"
    cookbook "ack"
    ' > Berksfile
    
    # download the cookbooks to berks-cookbooks
    berks install
    berks vendor
    
    # define the runlist for this machine   
    echo '
    {
      "run_list": [ "recipe[ack]" ]
    }' > node.json
    
    # create a simple chef config
    echo '
    here = File.expand_path(File.dirname(__FILE__)
    file_cache_path "#{here}/.cache"
    cookbook_path "#{here}/berks-cookbooks"
    json_attribs "#{here}/node.json"
       ' > chef-config.rb

    # run chef-solo
    sudo chef-solo -c chef-config -j node.json
    
    
