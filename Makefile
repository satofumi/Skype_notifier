# Skype_notifier

SPECIFICATION_DIR = generated_html
MANUAL_DIR = doc
VERSION = "0.0.1"
PACKAGE_NAME = "skype_notifier-"$(VERSION)


all : spec_html html

clean :
	$(RM) -rf $(SPECIFICATION_DIR) $(MANUAL_DIR)
	$(RM) -rf $(PACKAGE_NAME) $(PACKAGE_NAME).zip

spec_html : $(SPECIFICATION_DIR)/index.html

html : $(MANUAL_DIR)/index.html

package :
	mkdir -p $(PACKAGE_NAME)
	cp README.txt skype_notifier.rb Notify_list.rb sample_notify_messages.txt $(PACKAGE_NAME)
	zip -r $(PACKAGE_NAME).zip $(PACKAGE_NAME)/*


.PHONY : all clean html package
######################################################################
$(SPECIFICATION_DIR)/index.html : Doxyfile $(wildcard dox/*)
	doxygen

$(MANUAL_DIR)/index.html : $(wildcard *.rb test/*.rb)
	rdoc -c utf-8
