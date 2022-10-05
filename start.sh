#!/bin/sh

cd /app/web
[ -L "node_modules" ] && rm -rf node_modules
[ ! -L "node_modules" ] && ln -s /app/web2/node_modules node_modules

yarn run start
