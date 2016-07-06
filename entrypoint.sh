#!/bin/sh

if [ -n "${DNSSERVERS}" ]
then
	UNBOUND_CFGFILE="/etc/unbound/unbound.conf"
  echo "## Simple forward caching DNS
	server:
		interface: 0.0.0.0
	  	access-control: 0.0.0.0/0 allow
	    verbosity: 1
	    include: /etc/unbound/localrecords.conf

	forward-zone:
		name: "."
	">${UNBOUND_CFGFILE}

	for DNSSERVER in ${DNSSERVERS}
	do
		echo -e "\tforward-addr: ${DNSSERVER}" >> ${UNBOUND_CFGFILE}
	done

fi


[ ! -n "${DNSENTRIES}" ] && exec $@

RECORDS_FILE=/etc/unbound/localrecords.conf

#Alway recreate a new localrecords.conf file
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
