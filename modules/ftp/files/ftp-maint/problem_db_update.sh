#!/bin/bash

FILE_LOC=/opt/ftp-maint/problem_db
FILE_FTP=/srv/ftp/pub/lsb/updates/dist-checker-data/problem_db
FILE_BZR=http://bzr.linuxfoundation.org/lsb/devel/dtk-manager/autotest-ext/problem_db

bzr cat $FILE_BZR >$FILE_LOC || exit $?

if [ ! -f $FILE_FTP ] || ! diff -q $FILE_LOC $FILE_FTP
then
	echo Copy to $FILE_FTP
	cp -f $FILE_LOC $FILE_FTP
fi

