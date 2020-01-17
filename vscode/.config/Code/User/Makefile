THEME ?= gruvbox-dark
I3_HOME ?= $(HOME)/.i3

ifneq (,$(findstring -dark,$(THEME)))
	M4_CODE_BG = dark
else
	M4_CODE_BG = light
endif
FILES = settings.json

all: $(FILES)

clean:
	$(RM) $(FILES)

.PHONY: all clean

settings.json: settings.json.m4
	m4 -I. -I$(I3_HOME)/themes/$(THEME) -DM4_THEME=$(THEME) -DM4_CODE_BG=$(M4_CODE_BG) settings.json.m4 > settings.json

