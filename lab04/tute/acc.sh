#!/bin.sh

acc $1 | egrep ' [A-Z]{4}[0-9]{4}_Student' | tr ' ' '\n' | sed -nr 's/^([A-Z]{4}[0-9]{4})_Student.*$/\1/p'
