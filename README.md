# A Minimal Makefile For Burning .COM Files Into a Disk Image For the Z80-Retro

Note: This derived from the [example filesystem](https://github.com/Z80-Retro/example-filesystem)
repo.  The difference is that this repo does not compile/assemble anything.
It is intended to be used to copy all the .COM files in the `com` directory
into a disk image that can be burned onto an SD card.

The intended use for this is to REPLACE every file on a disk image.
Not to merge files into an existing one.

## TL;DR

For example, if you are on the standard Raspberry PI setup then to download
some games from [linuxplayground](https://github.com/linuxplayground/nabu-games/releases)
and copy them to the SD card slot for drive G: so you run them on your Retro,
you can do this:

```shell
	git clone https://github.com/Z80-Retro/Z80-Retro-disk-maker.git
	cd Z80-Retro-disk-maker
	wget https://github.com/linuxplayground/nabu-games/releases/download/v3.3/nabu-games-z80retro-v3.3.tgz
	tar zxvf nabu-games-z80retro-v3.3.tgz -C slot-7
	mv slot-7/snake/snake.com slot-7/snake.com
	mv slot-7/tetris/tetris.com slot-7/tetris.com
	make clean
	make burn
```

## Slots

This repo contains a seperate empty folder for each available slot.  They are
all pre-populated with a slot.txt file that contains the slot number.  This
isn't used by anything, but having it there makes the bulid simpler.

If you have less slots on your system, then update the SLOTS variable in your
Make.local file. See below for some discussion on using Make.local to override
Makefile settings for your system.

The Makefile does not find files in subfolders within a slot.  It does not
support user areas either. (Pull requests welcome!).  Place all the files you
would like to burn into whichever slot- directory you want.

Slots are numbered like this:

```text
A - slot-0 (DO NOT USE - NOT PROVIDED IN THIS REPO)
B - slot-1
C - slot-2
D - slot-3
E - slot-4
F - slot-5
G - slot-6
H - slot-7
```


## This is not a bootable disk!

Note that this will build a disk image that has no operating system on it.

See the [Z80 Retro! CP/M](https://github.com/Z80-Retro/2063-Z80-cpm) repo for
information on how to format an SD card and install a bootable image into 
`drive A` which we normally refer to as "slot zero".

This repo will create the 8mb disk images in the `images` directory for each
slot.  When you run `make burn` it will burn all the images to the SD Card at
the appropriate 8mb offsets.

## Before you begin...

Below is a discussion of how and where things are stored on an SD card suitable
for use in a Z80 Retro! system.  By default, the `Makefile` has been configured
to function out-of-the-box if you are using a Raspberry PI as your development
platform as seen in the [Z80 Retro! Playlist](https://youtube.com/playlist?list=PL3by7evD3F51Cf9QnsAEdgSQ4cz7HQZX5)
on the [John's Basement](https://www.youtube.com/@johnsbasement) YouTube channel.

If you are using a different system, you will want to create a `Make.local`
file to override the defaults as needed by your platform.  You should not have
to alter any of the other `Make*` files unless you are adding or removing
programs from the filesystem.

If you find this to be untrue then you are either doing it wrong or there is
an error in how this project has been prepared.  Please post comments to let
the maintainers know!

## cpmtools

We use the `cpmtools` package to do this.  On a Debian-derived linux system we
can install it like this:

```shell
	sudo apt install cpmtools
```

It is not documented, but a `diskdefs` file in the current directory will be
searched my the `cpmtools` commands for the given `-f` format:

```shell
	mkfs.cpm -f generic-8k-8m retro.img
```

Note that the above will save 0xe5 bytes into the directory are of the disk and
accomplish nothing more.

Once a filesystem has been initialized by the `mkfs.cpm command`, files can be
added to it like this:

```shell
	cpmcp -f generic-8k-8m retro.img myprog.com 0:
```

We can also look at what files are on the CP/M filesystem with the `cpmls`
command like this:

```shell
	cpmls -f generic-8k-8m retro.img
```

## Multiple filesystems on one SD card

We consider the one SD partition as a series of 8 megabyte `slots`.
The goal is to write one disk image (filesystem) to each slot on the disk
partition using the `dd` command by specifying where on the SD card to put each
one.

We consider the slots to be numbered 0-15.

Each slot is 16384 blocks in size (0x4000). seek=01x16384 - 16384 in decimal is
the start of the second disk slot.

## Where to find more CP/M programs for your system

For more apps that can run on your Retro! board, search the Internet for
variations of `cp/m software downloads` and 'cp/m game download' etc.

Some big archives that might keep you busy for a while can be found here:

	http://cpmarchives.classiccmp.org/
	https://ifarchive.org/indexes/if-archiveXgamesXcpm.html
	https://deramp.com/downloads/mfe_archive/040-Software/Digital%20Research/CPM%20Implementations/COMPUPRO/GAMES/

If you want something to cook on your CPU and test every instruction, you can
try `zexall.com` and `zexdoc.com` files found in the CPM.zip file located here:

	https://mdfs.net/Software/Z80/Exerciser/
