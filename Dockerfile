FROM haproxy
MAINTAINER <jon@wildducktheories.com>

RUN useradd -u 600 -d /home/haproxy -m haproxy
ADD wildduck-entrypoint.sh /

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
ENTRYPOINT ["/wildduck-entrypoint.sh"]
