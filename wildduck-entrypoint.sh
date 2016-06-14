#!/bin/bash

# Ensure that there is a combined file generated from the letsencrypt key and certificate materials.
if private=$(readlink -f /etc/letsencrypt/live/wildducktheories.com/privkey.pem) &&
	archive=$(dirname "$private") &&
	test -d "$archive"; then
	cat $private /etc/letsencrypt/live/wildducktheories.com/fullchain.pem > $archive/combined.pem.tmp
	if ! test -f $archive/combined.pem || ! cmp $archive/combined.pem.tmp $archive/combined.pem; then
		test -f $archive/combined.pem && echo "replacing existing combined key - sha1 - $(sha1sum $archive/combined.pem)" 1>&2
		mv $archive/combined.pem.tmp $archive/combined.pem
		echo "updated combined key - sha1 - $(sha1sum $archive/combined.pem)" 1>&2
	fi
	if ! test -L /etc/letsencrypt/live/wildducktheories.com/combined.pem; then
		ln -sf "$(dirname "$(readlink -f /etc/letsencrypt/live/wildducktheories.com/privkey.pem)")/combined.pem" /etc/letsencrypt/live/wildducktheories.com
	fi
	if test -f $archive/combined.pem.tmp; then
		rm $archive/combined.pem.tmp
	fi
else
	echo "letsencrypt key material has not been set up yet" 1>&2
fi

exec /docker-entrypoint.sh "$@"