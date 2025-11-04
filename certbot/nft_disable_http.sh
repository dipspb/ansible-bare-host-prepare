#!/bin/bash

# Removing firewall rules created for certbot renew certificates

me=$(basename "$0")

logger -t "$me" "Closing port 80 opened for certbot"

## Remove port 80 accept rules
for h in $(nft -a list chain filter input \
           | awk '/dport 80 .* accept .* # handle [0-9]+/ {print $NF}')
do
    nft delete rule filter input handle $h
done
