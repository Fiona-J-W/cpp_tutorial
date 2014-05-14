#!/bin/sh
pandoc  -fmarkdown -t latex -o cpp.pdf  \
		--toc \
		--number-sections \
		-V documentclass:book\
		-V papersize:"a4paper" \
	src/Intro.md \
	src/functions.md \
	src/reference.md \
	src/const.md \
	src/function_overloading.md \
	src/function_templates.md \
	src/classes.md \
	src/class_templates.md \
	src/inheritance.md
