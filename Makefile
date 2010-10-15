# Skype_notifier

HTML_DIR = generated_html

all : html

clean :
	$(RM) -rf $(HTML_DIR)

html : $(HTML_DIR)/index.html

package :


.PHONY : all clean html package
######################################################################
$(HTML_DIR)/index.html : Doxyfile $(wildcard dox/*)
	doxygen
