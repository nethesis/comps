XMLINFILES=$(wildcard *.xml.in)
XMLFILES = $(patsubst %.xml.in,%.xml,$(XMLINFILES))

all: po $(XMLFILES)

po: $(XMLINFILES)
	make -C po -f Makefile || exit 1

clean:
	@rm -fv *~ *.xml

validate: $(XMLFILES) comps.rng
	for f in $(XMLFILES); do xmllint --noout --relaxng comps.rng $$f; done

%.xml: %.xml.in
	@python -c 'import libxml2; libxml2.parseFile("$<")'
	@if test ".$(CLEANUP)" == .yes; then xsltproc --novalid -o $< comps-cleanup.xsl $<; fi
	./update-comps $@


