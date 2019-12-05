I3_HOME ?= $(HOME)/.i3
THEMES = $(basename $(notdir $(wildcard $(I3_HOME)/themes/*)))

all: $(THEMES)

clean:
	$(RM) -r $(THEMES)

.PHONY: all clean

$(THEMES): template.m4 #$(I3_HOME)/themes/$@/color.m4
	cp -r template.m4 $@
	m4 -DM4_CODE_THEME=$@ -DM4_CODE_BG=$(lastword $(subst -, ,$@)) $@/package.json.m4 > $@/package.json
	$(RM) $@/package.json.m4
	m4 -DM4_CODE_THEME=$@ -DM4_CODE_BG=$(lastword $(subst -, ,$@)) -I$(I3_HOME)/themes/$@ $@/themes/template.json.m4 > $@/themes/$@.json
	$(RM) $@/themes/template.json.m4

