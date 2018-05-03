#!/bin/sh
set -ex

if [ "$ENABLE_XDEBUG" = "true" ];
then
    docker-php-ext-enable xdebug
fi

exec "$@"
