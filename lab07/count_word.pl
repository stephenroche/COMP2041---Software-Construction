#!/usr/bin/perl -w

$target = lc $ARGV[0];
$count = 0;

while ($line = <STDIN>) {
   @words = split(/[^a-z]+/i, lc $line);
   foreach $word (@words) {
      $count++ if ($word eq $target);
   }
}

print "$target occurred $count times\n ";
