#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
command -v php >/dev/null || { echo 'PHP is required'; exit 1; }
command -v composer >/dev/null || { echo 'Composer is required'; exit 1; }
[ -f .env ] || cp .env.example .env
mkdir -p database storage/framework/{cache,sessions,views} storage/logs
touch database/database.sqlite
composer install --no-interaction
php artisan key:generate --force
php artisan migrate --force
php artisan optimize:clear
echo 'Ready: php artisan serve --host=0.0.0.0 --port=8000'
