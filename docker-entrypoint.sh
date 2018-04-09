#!/bin/bash
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate
php artisan serve --port=80 --host=0.0.0.0