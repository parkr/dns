#!/bin/bash

echo "--> Using curl"
curl --version
echo ; echo

echo "--> Using grep"
grep --version
grep --help
echo ; echo

for domain in $(script/list-domains | grep CNAME | grep '\-> parkr.github.io' | awk '{print $2}'); do
  echo "--> Testing $domain"
  echo "---------------------------------"

  outfile=$(mktemp)
  trap 'rm $outfile' EXIT
  time curl -sSfLv "https://$domain" > /dev/null 2>"$outfile"

  grep -E -e '< HTTP\/\d(\.\d)? 200' "$outfile" || {
    cat "$outfile"
    echo " !!! Not a 200"
    exit 1
  }

  echo ; echo;
done
