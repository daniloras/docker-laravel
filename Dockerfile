FROM php:alpine

RUN apk update && apk upgrade && apk add bash git

# Install PHP extensions
ADD install-php.sh /usr/sbin/install-php.sh
RUN /usr/sbin/install-php.sh

# Download and install NodeJS
ENV NODE_VERSION 8.0.0
ADD install-node.sh /usr/sbin/install-node.sh
RUN /usr/sbin/install-node.sh

RUN mkdir -p /etc/ssl/certs && update-ca-certificates

WORKDIR /var/www

EXPOSE 80

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 0700 /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]