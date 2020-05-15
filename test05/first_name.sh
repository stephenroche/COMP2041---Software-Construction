#!/bin/sh

egrep '^COMP[29]041' "$1" | sed -r 's/^.*, ([^ ]+) .*$/\1/' | sort | uniq -c | sort -n | tail -1 | cut -c9-
