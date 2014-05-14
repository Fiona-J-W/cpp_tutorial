#!/bin/sh
pandoc  -fmarkdown -t latex -o cpp.pdf  -V documentclass:book --toc --number-sections \
	src/Intro.md \
	src/functions.md \
	src/reference.md \
	src/const.md \
	src/function_overloading.md \
	src/function_templates.md \
	src/classes.md \
	src/class_templates.md
