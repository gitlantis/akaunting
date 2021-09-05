#!/bin/sh
#php artisan migrate:fresh --seed
#php artisan install:refresh 

php artisan install --db-host=${DB_HOST} --db-port=${DB_PORT} --db-name=${DB_DATABASE} --db-username=${DB_USERNAME} --db-password=${DB_PASSWORD} --db-prefix=${DB_PREFIX} --admin-email="${ADMIN_USER}" --admin-password="${ADMIN_PASSWORD}"
#php artisan install --db-host=db --db-name=akaunting --db-username=root --db-password="" --db-prefix=cxm_ --admin-email="${ADMIN_USER}" --admin-password="${ADMIN_PASSWORD}"
