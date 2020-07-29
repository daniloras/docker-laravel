FROM alpine:3.11

RUN apk --update add ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v3.11/php-7.4" >> /etc/apk/repositories

# Install packages
RUN apk --no-cache add php php-fpm php-mysqli php-pdo php-pdo_mysql php-json php-openssl \
    php-curl php-zlib php-xml php-xmlwriter php-phar php-intl php-dom php-xmlreader \
    php-ctype php-mbstring php-gd php-tokenizer php-soap php-bz2 php-fileinfo \
    php-simplexml php-session php-iconv php-zip php-gmp libmcrypt-dev libsodium nginx nodejs supervisor curl git mysql-client

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php && \
    mv composer.phar /usr/bin/composer && \
    chmod +x /usr/bin/composer

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

EXPOSE 80 443

CMD ["/bin/sh", "-c", "cp .env.example .env && composer install && npm install --verbose && php artisan key:generate || : && php artisan migrate && supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
