.PHONY: all
all: access.db canonical.db virtual.db relocated.db transport.db \
     sender_canonical.db

%.db: %
	/usr/sbin/postmap $<
