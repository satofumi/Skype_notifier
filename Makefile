# Skype_notifier

HTML_DIR = generated_html

all : html_old html

clean :
	$(RM) -rf $(HTML_DIR)
	$(RM) -rf doc/

html_old : $(HTML_DIR)/index.html

html : doc/index.html

package :


.PHONY : all clean html package
######################################################################
$(HTML_DIR)/index.html : Doxyfile $(wildcard dox/*)
	doxygen

doc/index.html : $(wildcard *.rb)
	rdoc -c utf-8
