#!/usr/bin/perl -w

while ($line = <STDIN>) {
   @words = split /[^a-z]+/i, $line;
   foreach $word (@words) {
      $count++ if $word;
   }
}

print "$count words\n ";
