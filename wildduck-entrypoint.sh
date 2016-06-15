#!/bin/bash

# Ensure that there is a combined file generated from the letsencrypt key and certificate materials.
if private=$(readlink -f /etc/letsencrypt/live/wildducktheories.com/privkey.pem) &&
	archive=$(dirname "$private") &&
	combined=${archive}/combined.pem
	test -d "$archive"; then
	cat $private /etc/letsencrypt/live/wildducktheories.com/fullchain.pem > ${combined}.tmp
	if ! test -f $combined || ! cmp ${combined}.tmp $combined; then
		test -f $combined && echo "replacing existing combined key - sha1 - $(sha1sum $combined)" 1>&2
		mv ${combined}.tmp $combined
		echo "updated combined key - sha1 - $(sha1sum $combined)" 1>&2
	fi
	if test "$(readlink -f /etc/letsencrypt/live/wildducktheories.com/combined.pem)" != "$combined"; then
		ln -sf "$(dirname "$(readlink /etc/letsencrypt/live/wildducktheories.com/privkey.pem)")/combined.pem" /etc/letsencrypt/live/wildducktheories.com
	fi
	if test -f ${combined}.tmp; then
		rm ${combined}.tmp
	fi
else
	echo "letsencrypt key material has not been set up yet" 1>&2
fi

exec /docker-entrypoint.sh "$@"