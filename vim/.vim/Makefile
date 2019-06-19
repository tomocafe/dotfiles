THEME ?= gruvbox-dark
I3_HOME ?= $(HOME)/.i3

FILES = theme gtkrc-2.0 gtk.css

all: $(FILES)

clean:
	$(RM) $(FILES)

purge:
	$(RM) -r backups swaps undos

.PHONY: all clean purge

theme: theme.m4 themes/$(THEME)/_theme.m4
	m4 -I. -Ithemes/$(THEME) -I$(I3_HOME)/themes/$(THEME) theme.m4 > theme

gtkrc-2.0: gtkrc-2.0.m4
	m4 -I. -Ithemes/$(THEME) -I$(I3_HOME)/themes/$(THEME) gtkrc-2.0.m4 > gtkrc-2.0

gtk.css: gtk.css.m4
	m4 -I. -Ithemes/$(THEME) -I$(I3_HOME)/themes/$(THEME) gtk.css.m4 > gtk.css

