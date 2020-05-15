#!/usr/bin/perl -w

foreach $word (@ARGV) {
   if (!$seen{$word}) {
      $seen{$word} = 1;
      print "$word ";
   }
}

print "\n";
