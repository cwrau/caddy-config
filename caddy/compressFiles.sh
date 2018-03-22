#!/bin/bash

find /caddy/conf.d/_.d -type f -not -name '*.br' -not -name '*.gz' -exec gzip -v -k -f -9 {} \;

find /caddy/conf.d/_.d -type f -not -name '*.br' -not -name '*.gz' -exec brotli -v -f {} \;
