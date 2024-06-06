### 
# Based on https://github.com/tiangolo/nginx-rtmp-docke
###

FROM chaimfn/buildpack-deps:20.04.netfree
RUN apt update -y
RUN apt install -y openssl libssl-dev
ADD nginx-1.26.0 nginx-src
ADD nginx-rtmp-module nginx-rtmp-module
WORKDIR nginx-src

## Build and install Nginx
### The default puts everything under /usr/local/nginx, so it's needed to change
### it explicitly. Not just for order but to have it in the PATH
RUN ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --with-http_ssl_module \
        --with-threads \
        --with-ipv6 \
        --add-module=/nginx-rtmp-module \
	--with-debug \
    && make && make install

## Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

## Save original nginx config, modules and default html pages, etc.
RUN mkdir -p /etc/nginx/conf.d
RUN mkdir -p /usr/lib/nginx/modules
ADD src/usr/lib/nginx/modules /usr/lib/nginx/modules
ADD src/usr/share/nginx/html /usr/share/nginx/html/

## The directory below is contains the correct nginx.conf, who contains the 'rtmp' config section
ADD src/etc/nginx /etc/nginx

## Create directory for the records, and give correct permissions
RUN mkdir /tmp/record
RUN chown -R nobody:nogroup /tmp/record
RUN chmod -R 700 /tmp/record

## Remove unnecessary build files
WORKDIR /
RUN rm -rf nginx-src nginx-rtmp-module
RUN apt autoremove -y && apt clean -y

## Necessary potrs
EXPOSE 1935
EXPOSE 80
EXPOSE 443

## Start the server
CMD ["nginx", "-g", "daemon off;"]
