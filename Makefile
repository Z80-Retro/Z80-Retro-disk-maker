# Make 'all' first so that it is THE default target.

# List of all the slots from 1 to 7.  Slot 0 is reserved for the OS
SLOTS=1 2 3 4 5 6 7
CPM=../2063-Z80-cpm/filesystem/drive.img

# The :: means that if there is more than one of the same target name 
# then process all the occurrences one after the other.
all:: $(SLOTS)

TOP=.

# include things that might be of interest to more than just this Makefile
include $(TOP)/Make.default
-include $(TOP)/Make.local		# The - on this means ignore it if the file does not exist

burn: $(SLOTS:%=images/slot-%.img)
	@ if [ `hostname` != "$(SD_HOSTNAME)" -o ! -b "$(SD_DEV)" ]; then\
		echo "\nWARNING: You are either NOT logged into $(SD_HOSTNAME) or there is no $(SD_DEV) mounted!\n"; \
		false; \
	fi
	@count=1; \
	for d in $^; do \
		sudo dd if=$$d of=$(SD_DEV) bs=512 seek=$$(( $$count*16384 )) conv=fsync; \
		count=$$((count+1)); \
	done

ls:: $(SLOTS:%=images/slot-%.img)
	
	@for d in $^; do \
		echo $$d; \
		cpmls -f $(DISKDEF) $$d; \
		echo; \
	done

%: slot-%
	rm -f images/slot-$@.img
	mkfs.cpm -f $(DISKDEF) images/slot-$@.img
	cpmcp -f $(DISKDEF) images/slot-$@.img  $(filter-out $^/.gitignore, $(wildcard $^/*)) 0:


clean:
	rm -f images/*.img

world: clean all
