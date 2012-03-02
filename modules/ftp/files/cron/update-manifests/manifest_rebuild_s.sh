rm -rf distribution-checker
bzr export distribution-checker http://bzr.linuxfoundation.org/lsb/devel/distribution-checker \
	&& cat distribution-checker/utils/Tests/templates/*.mnf.tpl distribution-checker/utils/Tests/templates/manual/*.mnf.tpl >Manifest.tpl; ./manifest_gen.pl --dir /srv/ftp Manifest.tpl -o Manifest \
	&& echo "copy" && cp Manifest /srv/ftp/pub/lsb/updates/dist-checker-data/Manifest \
	&& rm -rf distribution-checker