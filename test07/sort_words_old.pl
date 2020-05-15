#!/usr/bin/perl -w

while ($line = <STDIN>) {
   @words = split(/\s+/, $line);
   foreach $word (sort @words) {
      print "$word ";
   }
   print "\n";
}
