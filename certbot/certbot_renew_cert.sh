#!/usr/bin/env bash
/opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && sudo /usr/local/bin/certbot renew -q
