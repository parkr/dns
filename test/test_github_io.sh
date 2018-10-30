#!/bin/bash

for domain in $(script/list-domains | grep CNAME | grep '\-> parkr.github.io' | awk '{print $2}'); do
  echo "--> Testing $domain"
  echo "---------------------------------"

  outfile=$(mktemp)
  trap 'rm $outfile' EXIT
  time curl -sSfLv "https://$domain" > "$outfile" 2>&1

  grep "< HTTP/2 200" "$outfile" || {
    cat "$outfile"
    echo " !!! Not a 200"
    exit 1
  }

  echo ; echo;
done
