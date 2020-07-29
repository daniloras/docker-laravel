FROM alpine:3.8

# Install packages
RUN apk --no-cache add php7.2 php7.2-fpm php7.2-mysqli php7.2-pdo php7.2-pdo_mysql php7.2-json php7.2-openssl \
    php7.2-curl php7.2-zlib php7.2-xml php7.2-xmlwriter php7.2-phar php7.2-intl php7.2-dom php7.2-xmlreader \
    php7.2-ctype php7.2-mbstring php7.2-gd php7.2-tokenizer php7.2-soap php7.2-bz2 php7.2-fileinfo \
    php7.2-simplexml php7.2-session php7.2-iconv php7.2-zip nginx nodejs supervisor curl git mysql-client

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7.2/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7.2/conf.d/zzz_custom.ini

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
