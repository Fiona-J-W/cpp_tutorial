
SOURCES=$(shell ls -1 src/*.md | sort)

all: pdf/book.pdf html

clean:
	rm pdf/book.pdf
	rm html/*.html

pdf/book.pdf: $(SOURCES)
	pandoc -fmarkdown -t latex -p -o pdf/book.pdf\
		--toc --number-sections -V documentclass:scrbook\
		$(SOURCES)


html/%.html: 
	pandoc -fmarkdown --mathml -t html5 -p -s -o $@ $< \
		-H "web/style.html" -A "web/license.html"

html/CC_BY_SA.png: web/CC_BY_SA.png
	cp web/CC_BY_SA.png html

html: html/intro.html html/getting_started.html html/functions.html\
	html/references.html html/const.html html/function_templates.html\
	html/classes.html html/class_templates.html html/inheritance.html\
	html/stdlib.html html/memory.html html/index.html html/CC_BY_SA.png

html/index.html:              web/index.md
html/Intro.html:              src/00_intro.md
html/getting_started.html:    src/01_getting_started.md
html/functions.html:          src/02_functions.md
html/references.html:         src/03_references.md
html/const.html:              src/04_const.md
html/function_templates.html: src/05_function_templates.md
html/classes.html:            src/06_classes.md
html/class_templates.html:    src/07_class_templates.md
html/inheritance.html:        src/08_inheritance.md
html/stdlib.html:             src/09_stdlib.md
html/memory.html:             src/10_memory.md
