#!/bin/sh

[ ! -n "${DNSENTRIES}" ] && exec $@

RECORDS_FILE=/etc/unbound/localrecords.conf

>$RECORDS_FILE

ReverseFQDN(){
	reversefqdn=
	echo $1
	OLD_IFS="$IFS"
	IFS="."
	for piece in $1
	do
		reversefqdn="${piece}.${reversefqdn}"
	done
	IFS=$OLD_IFS
	echo $reversefqdn
}

for line in ${DNSENTRIES}
do
echo "$line"

IP="$(echo $line|cut -d "@" -f2)"
FQDNAME="$(echo $line|cut -d "@" -f1)"

REVERSENAME=$(ReverseFQDN $FQDNAME)

# A Record
echo "local-data: \"${FQDNAME}. A ${IP}\"" >> $RECORDS_FILE

# PTR Record
echo "local-data-ptr: \"${IP} ${FQDNAME}.\""  >> $RECORDS_FILE

done

exec $@
