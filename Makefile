#Author: Polonio Davide <poloniodavide@gmail.com>
#License: GPLv3

OUTPUT_NAME= SecurityAndRiskManagement
LIST_NAME= listOfSections.tex
PATH_OF_CONTENTS= res/sections
MAIN_FILE= main
CC= latexmk
JOB_NAME=-jobname='$(OUTPUT_NAME)'
CCFLAGS= -pdflatex='pdflatex -interaction=nonstopmode' -quiet -pdf
SHELL := /bin/bash #Need bash not shell

all: compile

autogen:
	if [[ -a "res/$(LIST_NAME)" ]]; then echo "Removing res/$(LIST_NAME)"; \
		rm res/$(LIST_NAME); fi; \
	for i in $(sort $(wildcard $(PATH_OF_CONTENTS)/*.tex)); do \
		echo "Adding $$i into $(LIST_NAME)"; \
		echo "\input{$$i}" >> res/$(LIST_NAME); \
	done; \

compile: autogen
	$(CC) -C $(JOB_NAME); \
	$(CC) $(CCFLAGS) $(JOB_NAME); \

alt:
	cd tools/; \
	perl answersRemover.pl; \
	cd ../;

alternative: alt compile

examautogen:
	perl tools/examVerMaker.pl;

exam: examautogen alt
	$(CC) -C $(JOB_NAME); \
	$(CC) $(CCFLAGS) $(JOB_NAME); \

clean:
	if [[ -a res/sections/89-Answers.tex ]]; \
	then \
		rm res/sections/89-Answers.tex; \
	fi; \
	git checkout -- res/sections/*.tex
	git clean -Xfd
	$(CC) -C $(JOB_NAME)
	if [[ -a "$(OUTPUT_NAME)" ]]; then rm -rv $(OUTPUT_NAME)/; fi;
