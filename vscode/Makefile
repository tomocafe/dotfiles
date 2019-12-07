I3_HOME ?= $(HOME)/.i3
THEMENAMES = $(basename $(notdir $(wildcard $(I3_HOME)/themes/*)))
THEMES = $(addprefix theme-,$(THEMENAMES))
VERSION ?= devel
TARBALL = unified-themes-$(VERSION).tar.gz

all: $(THEMES)

clean:
	$(RM) -r $(THEMES)
	$(RM) $(TARBALL)

release: $(TARBALL)

.PHONY: all clean release

$(THEMES): template.m4 #$(I3_HOME)/themes/$@/color.m4
	cp -r template.m4 $@
	m4 -DM4_VERSION=$(VERSION) -DM4_CODE_THEME=$(@:theme-%=%) -DM4_CODE_BG=$(lastword $(subst -, ,$@)) $@/package.json.m4 > $@/package.json
	$(RM) $@/package.json.m4
	m4 -DM4_VERSION=$(VERSION) -DM4_CODE_THEME=$(@:theme-%=%) -DM4_CODE_BG=$(lastword $(subst -, ,$@)) -I$(I3_HOME)/themes/$(@:theme-%=%) $@/themes/template.json.m4 > $@/themes/$(@:theme-%=%).json
	$(RM) $@/themes/template.json.m4
	#cd $@ && vsce package

$(TARBALL): $(THEMES)
	tar czvf $@ $(THEMES)

