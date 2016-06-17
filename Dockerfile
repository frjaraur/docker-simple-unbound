FROM alpine
RUN apk --update add unbound 
#RUN /usr/sbin/unbound-anchor -a /etc/unbound/root.key
COPY unbound.conf /etc/unbound/unbound.conf
COPY records.conf /etc/unbound/records.conf
EXPOSE 53/udp

CMD ["unbound","-d"]
