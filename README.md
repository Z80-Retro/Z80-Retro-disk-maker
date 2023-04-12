# A Minimal Makefile For Burning .COM Files Into a Disk Image For the Z80-Retro

Note: This derived from the [example filesystem](https://github.com/Z80-Retro/example-filesystem) repo.  The difference is that this repo does not compile/assemble anything.  It is intended to be used to copy all the .COM files in the `com` directory into a disk image that can be burned onto an SD card.

The intended use for this is to REPLACE every file on a disk image.  Not to merge files into an
existing one.

## TL;DR

For example, if you are on the standard Raspberry PI setup then to download some games from [linuxplayground](https://github.com/linuxplayground/nabu-games/releases) and copy them to the SD card slot for drive E: so you run them on your Retro, you can do this:

	wget https://github.com/linuxplayground/nabu-games/releases/download/v3.3/nabu-games-z80retro-v3.3.tgz
	tar zxvf nabu-games-z80retro-v3.3.tgz -C apps
	make
	make burn

To change the drive slot number, create a `Make.local` as discussed in the `Make.default` file.

## This is not a bootable disk!

Note that this will build a disk image that has no operating system on it.

See the [Z80 Retro! CP/M](https://github.com/Z80-Retro/2063-Z80-cpm) repo for information on how to format
an SD card and install a bootable image into `drive A` which we normally refer to as "slot zero".

The image created by this Makefile is intended to be stored into any slot OTHER than slot zero.

## Before you begin...

Below is a discussion of how and where things are stored on an SD card suitable for use
in a Z80 Retro! system.  By default, the `Makefile` has been configured to function
out-of-the-box if you are using a Raspberry PI as your development platform as seen
in the 
[Z80 Retro! Playlist](https://youtube.com/playlist?list=PL3by7evD3F51Cf9QnsAEdgSQ4cz7HQZX5) 
on the [John's Basement](https://www.youtube.com/@johnsbasement) YouTube channel.

If you are using a different system, you will want to create a `Make.local` file to
override the defaults as needed by your platform.  You should not have to alter
any of the other `Make*` files unless you are adding or removing programs from the 
filesystem.

If you find this to be untrue then you are either doing it wrong or there is an error
in how this project has been prepared.  Please post comments to let the maintainers know!

## cpmtools

We use the `cpmtools` package to do this.  On a Debian-derived linux system we can install it like this:

	sudo apt install cpmtools

It is not documented, but a `diskdefs` file in the current directory will be searched my the `cpmtools` commands for the given `-f` format:

	mkfs.cpm -f generic-8k-8m retro.img

Note that the above will save 0xe5 bytes into the directory are of the disk and accomplish nothing more.

Once a filesystem has been initialized by the `mkfs.cpm command`, files can be added to it like this:

	cpmcp -f generic-8k-8m retro.img myprog.com 0:

We can also look at what files are on the CP/M filesystem with the `cpmls` command like this:

	cpmls -f generic-8k-8m retro.img

## Multiple filesystems on one SD card

We consider the one SD partition as a series of 8 megabyte `slots`.  
The goal is to write one disk image (filesystem) to each slot on the disk partition 
using the `dd` command by specifying where on the SD card to put each one.

We consider the slots to be numbered 0-15. 

Each slot is 16384 blocks in size (0x4000). seek=01x16384 - 16384 in decimal is the start of the
second disk slot. 

To change the slot number used by the `Makefile`, you can create a `Make.local` file to override
the default slot number that can be found in the `Make.default` file.

For example, one way to create a new `Make.local` file and/or delete any existing one and replace
it with one line to change the slot number to 5 (for drive F:), you could do this:

	echo "DISK_SLOT=5" > Make.local

## Where to find more CP/M programs for your system

For more apps that can run on your Retro! board, search the Internet for variations of `cp/m software downloads` and 'cp/m game download' etc.

Some big archives that might keep you busy for a while can be found here:

	http://cpmarchives.classiccmp.org/
	https://ifarchive.org/indexes/if-archiveXgamesXcpm.html
	https://deramp.com/downloads/mfe_archive/040-Software/Digital%20Research/CPM%20Implementations/COMPUPRO/GAMES/

If you want something to cook on your CPU and test every instruction, you can try
`zexall.com` and `zexdoc.com` files found in the CPM.zip file located here:

	https://mdfs.net/Software/Z80/Exerciser/
