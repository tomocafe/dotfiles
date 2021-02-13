# Find large files and shard them, then restore them
#
# You can override SHARD_FILES, SHARD_SIZE, and SUFFIX via command line:
#
#     $ make -f shard.mk SHARD_SIZE=10G
#
# or wrap this in another Makefile and define these variables:
#
#	  SHARD_FILES := $(shell find -name "*.mp4" -o -name "*.m4a")
#	  include shard.mk

SHARD_SIZE  ?= 32M
SHARD_FILES ?= $(shell find -type f -size +$(SHARD_SIZE))
SUFFIX      ?= shards
RESTORED    := $(SHARD_FILES)
SHARDED     := $(shell find -name "*.$(SUFFIX)")
SHARD       := $(filter-out $(SHARDED),$(addsuffix .$(SUFFIX),$(RESTORED)))
RESTORE     := $(filter-out $(RESTORED),$(SHARDED:%.$(SUFFIX)=%))

help:
	@echo "make status - lists sharded and restored files"
	@echo "make shard - shards all files"
	@echo "make restore - restores all files"
	@echo "make FILE.EXT.$(SUFFIX) - shards FILE.EXT to create FILE.EXT.$(SUFFIX)"
	@echo "make FILE.EXT - restores FILE.EXT from FILE.EXT.$(SUFFIX)"

status:
	@echo "Unsharded files: $(RESTORED)"
	@echo "To shard: $(SHARD)"
	@echo "Sharded files: $(SHARDED)"
	@echo "To restore: $(RESTORE)"

shard: $(SHARD)

restore: $(RESTORE)

$(SHARD): %.$(SUFFIX): %
	mkdir $@
	gzip < $< | split -b$(SHARD_SIZE) - $@/$(notdir $<).gz

$(RESTORE): %: %.$(SUFFIX)
	cat $</$(notdir $@).* | gunzip > $@

