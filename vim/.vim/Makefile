THEME ?= gruvbox-dark
I3_HOME ?= $(HOME)/.i3

ifneq (,$(findstring -dark,$(THEME)))
	M4_VIM_BG = dark
else
	M4_VIM_BG = light
endif
FILES = colors/unified.vim gtkrc-2.0 gtk.css

all: $(FILES)

clean:
	$(RM) $(FILES)

purge:
	$(RM) -r backups swaps undos

.PHONY: all clean purge

colors/unified.vim:
	m4 -I. -I$(I3_HOME)/themes/$(THEME) -DM4_VIM_BG=$(M4_VIM_BG) colors/unified.vim.m4 > colors/unified.vim

gtkrc-2.0: gtkrc-2.0.m4
	m4 -I. -I$(I3_HOME)/themes/$(THEME) gtkrc-2.0.m4 > gtkrc-2.0

gtk.css: gtk.css.m4
	m4 -I. -I$(I3_HOME)/themes/$(THEME) gtk.css.m4 > gtk.css

