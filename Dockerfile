FROM ubuntu:14.04
MAINTAINER Jonathan Garbee <jonathan@garbee.me>

ENV NPS_VERSION 1.9.32.3
ENV NGINX_VERSION 1.6.2

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev gcc libc6-dev libc6 openssl && \
    cd /tmp && \
    wget https://github.com/pagespeed/ngx_pagespeed/archive/v${NPS_VERSION}-beta.tar.gz && \
    tar -xf v${NPS_VERSION}-beta.tar.gz && \
    cd ngx_pagespeed-${NPS_VERSION}-beta/ && \
    wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz && \
    tar -xzvf ${NPS_VERSION}.tar.gz && \
    cd /tmp && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp/nginx-${NGINX_VERSION}/ && \
    ./configure \
    --with-ipv6 \
    --sbin-path=/usr/local/bin/ \
    --conf-path=/usr/local/etc/nginx/nginx.conf \
    --pid-path=/run/nginx.pid \
    --with-http_ssl_module \
    --with-http_spdy_module \
    --add-module=/tmp/ngx_pagespeed-${NPS_VERSION}-beta && \
    make && \
    make install && \
    make clean && \
    cd /tmp && \
    rm -rf * && \
    mkdir -p /var/log/nginx && \
    touch /var/log/nginx/access.log && \
    touch /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx", "/usr/local/etc/nginx/sites-enabled", "/etc/ssl/certs"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
