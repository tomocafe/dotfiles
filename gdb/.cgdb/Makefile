THEME ?= gruvbox-dark

ifneq (,$(findstring -dark,$(THEME)))
	M4_CGDB_BG = dark
else
	M4_CGDB_BG = light
endif
FILES = cgdbrc

all: $(FILES)

clean:
	$(RM) $(FILES)

.PHONY: all clean

cgdbrc: cgdbrc.m4
	m4 -DM4_CGDB_BG=$(M4_CGDB_BG) cgdbrc.m4 > cgdbrc

