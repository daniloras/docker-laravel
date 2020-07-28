FROM alpine:3.7

# Install packages
RUN apk --no-cache add php7.3 php7.3-fpm php7.3-mysqli php7.3-pdo php7.3-pdo_mysql php7.3-json php7.3-openssl \
    php7.3-curl php7.3-zlib php7.3-xml php7.3-xmlwriter php7.3-phar php7.3-intl php7.3-dom php7.3-xmlreader \
    php7.3-ctype php7.3-mbstring php7.3-gd php7.3-tokenizer php7.3-soap php7.3-bz2 php7.3-fileinfo \
    php7.3-simplexml php7.3-session php7.3-iconv php7.3-zip nginx nodejs supervisor curl git mysql-client

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7.3/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7.3/conf.d/zzz_custom.ini

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
