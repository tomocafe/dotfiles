THEME ?= gruvbox-dark

all: config Xresources dunstrc

config: config.m4 font.m4
	m4 -I. -Ithemes/$(THEME) config.m4 > config

Xresources: Xresources.m4
	m4 -I. -Ithemes/$(THEME) Xresources.m4 > Xresources

dunstrc: dunstrc.m4
	m4 -I. -Ithemes/$(THEME) dunstrc.m4 > dunstrc

clean:
	rm -f config Xresources dunstrc

