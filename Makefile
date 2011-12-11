#!/usr/bin/make

PACKAGE  = w3-dtd-mathml
VERSION  = $(shell head -n 1 $(PACKAGE)/debian/changelog \
             | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\1/')
DEBREV   = $(shell head -n 1 $(PACKAGE)/debian/changelog \
             | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\2/')
DEB      = $(PACKAGE)_$(VERSION)-$(DEBREV)
DEBUILD  = debuild
DEBUILDOPTS=
PBUILDER = cowbuilder
PBOPTS   = --hookdir=pbuilder-hooks \
           --bindmounts "/var/cache/pbuilder/result"

.PHONY: all mostlyclean clean

all: $(DEB)_all.deb

$(DEB)_all.deb: $(DEB).dsc $(DEB).tar.gz
	sudo $(PBUILDER) --build $< -- $(PBOPTS)
	cp /var/cache/pbuilder/result/$@ ./

$(DEB).dsc $(DEB).tar.gz:
	(cd $(PACKAGE); $(DEBUILD) $(DEBUILDOPTS); cd -)

mostlyclean:
	-rm -fr $(DEB).dsc $(DEB)*.build $(DEB)*.changes $(DEB).tar.gz
	(cd $(PACKAGE); $(DEBUILD) $(DEBUILDOPTS) clean; cd -)

clean: mostlyclean
	-rm -fr $(DEB)_all.deb
