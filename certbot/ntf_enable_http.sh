#!/bin/bash

# Open firewall to let certbot renew certificates

me=$(basename "$0")

logger -t "$me" "Opening port 80 for certbot"

## Reverse order since we do inserts
nft insert rule ip filter input              tcp dport 80 counter                                accept comment \"Allow HTTP for certbot\"
nft insert rule ip filter input ct state new tcp dport 80 log prefix \"nft:ok-certbot \" group 0 accept comment \"Allow and log HTTP for certbot\"
