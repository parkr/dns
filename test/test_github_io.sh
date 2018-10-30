#!/bin/bash

for domain in $(script/list-domains | grep CNAME | grep '\-> parkr.github.io' | awk '{print $2}'); do
  echo "Testing $domain"
  resp=$(curl -sSfLv "https://$domain" 2>&1)

  echo "$resp" | grep "< HTTP/2 200" || {
    echo " !!! Not a 200"
    exit 1
  }
done
