#!/usr/bin/perl -w

while ($line = <STDIN>) {
   $count{$line}++;
   if ($count{$line} >= $ARGV[0]) {
      print "Snap: $line";
      exit;
   }
}
