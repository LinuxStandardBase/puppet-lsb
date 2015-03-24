#!/bin/sh -e

rm -rf distribution-checker
bzr export distribution-checker http://bzr.linuxfoundation.org/lsb/devel/distribution-checker

cat distribution-checker/utils/Tests/templates/*.mnf.tpl distribution-checker/utils/Tests/templates/manual/*.mnf.tpl >Manifest.tpl
./distribution-checker/utils/manifest_gen.pl --dir /srv/ftp Manifest.tpl -o Manifest

cp Manifest /srv/ftp/pub/lsb/updates/dist-checker-data/Manifest

# Copy any updated test modules.  Ideally, we'd figure this out from the
# Manifest we just generated, but for now let's just hard-code a list.

for m in Core_test.pm; do
    cp -f distribution-checker/utils/Tests/$m /srv/ftp/pub/lsb/updates/dist-checker-data
done

rm -rf distribution-checker
