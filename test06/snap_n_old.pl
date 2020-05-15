#!/usr/bin/perl -w

while ($line = <STDIN>) {
   $lines{$line}++;
   if ($lines{$line} >= $ARGV[0]) {
      print "Snap: $line";
      exit;
   }
}
