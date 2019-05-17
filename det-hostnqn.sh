#!/bin/bash

LC_ALL=C

UUID=$(dmidecode -s system-uuid | tr -d '[:space:]')

if [ -z "$UUID" ] ; then
	>&2 echo "No UUID found, can't determine hostnqn."
	exit 1
fi

# convert UUID to lower-case only:
UUID=$(echo $UUID | tr '[:upper:]' '[:lower:]')

# check UUID format, e.g.: 4c4c4544-0156-4z10-8134-b7d04f383232, so: 8-4-4-4-12
if ! [[ $UUID =~ ^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$ ]] ; then
	>&2 echo "UUID has invalid format."
	>&2 echo "Invalid UUID: ${UUID}"
	exit 2
fi

# HEURISTIC: if any one given character occurs more than 30% of the time, it is
# likely that the UUID is fake.
for i in {{0..9},{a..z}} ; do
	COUNT="${UUID//[^$i]}"
	if [ ${#COUNT} -ge 11 ] ; then
		>&2 echo "UUID is too repetitive. This may be a false alert."
		>&2 echo "Repetitive UUID: ${UUID}"
		exit 3
	fi
done

HOSTNQN="nqn.2014-08.org.nvmexpress:uuid:${UUID}"

echo $HOSTNQN
