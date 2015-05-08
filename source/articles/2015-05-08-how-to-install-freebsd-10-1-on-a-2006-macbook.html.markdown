---
title: How To Install FreeBSD 10.1 On A 2006 Macbook
date: 2015-05-08 20:45 CEST
tags: freebsd 
---

A while ago I decided to unretire my [2006 Macbook](http://www.everymac.com/systems/apple/macbook/specs/macbook_2.0_white.html) and turn it into a low powered server. Specifically to run a [BBS](http://www.synchro.net/), but more on that in a later blog post. To get FreeBSD running properly requires a bit of trickery, so i decided to write a little howo to save you some time and effort. For this you will need the following:

**Perquisites**

* A FreeBSD install DVD burned with the [i386 image](http://ftp.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/10.1/FreeBSD-10.1-RELEASE-i386-dvd1.iso) as we're dealing with a 32 bit core duo machine here. If you're into that sort of think you can also create a [FreeBSD USB stick](http://www.sysarchitects.com/using-mac-os-x-106-create-bootable-freebsd-81-installer-usb-memory-stick).
* The OS X Tiger (10.4) Install DVD

**Now for the fun part:**

* Insert DVD/USB stick into Macbook and boot

* Hold down the option key to choose to boot from the DVD/USB stick. The boot media should be displayed as "Windows" by the Mac boot manager

* Install FreeBSD with default partitions and whichever options you want

* With 10.1 I kept getting a

~~~bash
No bootable device -- insert boot disk and press any key
~~~

[message on bootup](http://www.beastielabs.net/freebsd-glitches.html). This can easily be fixed by exiting to the shell after the install and typing in

~~~bash
/sbin/gpart set -a active adaX
~~~

where adaX is the boot partition. I think this is ada0s1 on the Macbook with the default partition options, but i'm not 100% sure. Please feel free to correct me in the comments if i'm wrong.

* Exit and reboot. While rebooting hold down the left trackpad button to eject the DVD. Obviously if you're installing from USB this shouldn't be an issue. Insert the OS X Tiger install DVD and reboot again.

* Hold down the C button during the chime to boot from the Tiger DVD. Once booted choose your language and then open the terminal (Utilities/Terminal). Now you need to bless the boot partition (Yes, the engineers at Apple have quite the ego). Type the following in the shell:

~~~bash
bless --device /dev/disk0s1 --setBoot --legacy
~~~

* Reboot again and you should be rewarded with the FreeBSD boot screen:

![FreeBSD boot screen](/images/bsdinstall-newboot-loader-menu.png)

Now pat yourself on the back for a job well done. You deserve it.

![Pat yourself on the back](/images/patontheback.gif)
