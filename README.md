# docker-unbound

You can use DNSSERVERS variable for changing default google forwarders to your own servers

docker run -d -P -e DNSSERVERS="208.67.222.222 208.67.220.220" frjaraur/docker-simple-unbound


Localrecords Examples...


To replace entries use a file in this format or
add entries to variable DNSENTRIES in the format FQDN@IP

for example to create following entries we used
DNSENTRIES="ten.zero.zero.one@10.0.0.1 ten.zero.zero.two@10.0.0.2"

local-data: "ten.zero.zero.one. A 10.0.0.1"

local-data-ptr: "10.0.0.1 ten.zero.zero.one."

local-data: "ten.zero.zero.two. A 10.0.0.2"

local-data-ptr: "10.0.0.2 ten.zero.zero.two."


docker run -d -P  -e DNSENTRIES="ten.zero.zero.one@10.0.0.1 ten.zero.zero.two@10.0.0.2" frjaraur/docker-simple-unbound


###########

EXAMPLE:

docker run -d -P -e DNSSERVERS="208.67.222.222 208.67.220.220" -e DNSENTRIES="ten.zero.zero.one@10.0.0.1 ten.zero.zero.two@10.0.0.2" frjaraur/docker-simple-unbound


NOTE:
Instead of DNSENTRIES variable, you can create your own "localrecords.conf" file and use it...

docker run -d -p 53:53/udp -v $(pwd)/localrecords.conf:/etc/unbound/localrecords.conf frjaraur/docker-simple-unbound


