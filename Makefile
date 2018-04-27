SHELL = /bin/bash
XMLINFILES=$(wildcard *.xml.in)
XMLFILES = $(patsubst %.xml.in,%.xml,$(XMLINFILES))

all: po $(XMLFILES) link

po: $(XMLINFILES)
	make -C po -f Makefile || exit 1

clean:
	@rm -fv *~ *.xml

validate: $(XMLFILES) comps.rng
	for f in $(XMLFILES); do xmllint --noout --relaxng comps.rng $$f; done

%.xml: %.xml.in
	@python -c 'import libxml2; libxml2.parseFile("$<")'
	@if [[ ".$(CLEANUP)" == .yes ]] ; then xsltproc --novalid -o $< comps-cleanup.xsl $<; fi
	./update-comps $@

link: nethserver-enterprise-groups.xml
	ln -sf nethserver-enterprise-groups.xml nethesis-updates-groups.xml

.ONESHELL:
upload: link
	@# Upload via sftp
	declare -A "endpoints=($${ENDPOINTS_PACK})"
	if [[ -f ~/.ssh/id_rsa.comps ]]; then
		echo "[ERROR] The private RSA key file already exists!"
		exit 1
	fi
	trap 'rm -f ~/.ssh/id_rsa.comps; ssh-agent -k' EXIT
	touch ~/.ssh/id_rsa.comps
	chmod 400 ~/.ssh/id_rsa.comps
	curl -s "$${SECRET_URL}" > ~/.ssh/id_rsa.comps
	eval $$(ssh-agent)
	expect << EOF
	  spawn ssh-add ~/.ssh/id_rsa.comps
	  expect "Enter passphrase"
	  send "$${SECRET}\r"
	  expect eof
	EOF
	unset SECRET SECRET_URL
	echo -e "put nethesis-updates-groups.xml" | sftp -i ~/.ssh/id_rsa.comps -b - "$${endpoints[$${DEST_ID}_$${NSVER}_updates]:?invalid ENDPOINT}"
