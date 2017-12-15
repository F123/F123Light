PREFIX = /usr/local

po :
	$(MAKE) -C i18n


install : sh mo

sh :
	touch sh.token

mo : en

en :
	install -m0755 -d $(PREFIX)/share/locale/$@/LC_MESSAGES
	install -m0644 -t $(PREFIX)/share/locale/$@/LC_MESSAGES ./locale/$@/LC_MESSAGES/pacstrap-f123pi.mo




uninstall :
	find $(PREFIX) -name "pacstrap-f123pi*" -exec rm {} \;
	find $(PREFIX) -name "bootstrap-f123pi*" -exec rm {} \;

