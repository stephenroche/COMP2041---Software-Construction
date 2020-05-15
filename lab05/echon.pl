#!/usr/bin/perl -w

if (@ARGV != 2) {
   print "Usage: $0 <number of lines> <string>\n";
   exit;
}

if (!($ARGV[0] =~ /^\d+$/)) {
   print "$0: argument 1 must be a non-negative integer\n";
   exit; 
}

$n=0;
while ($n < $ARGV[0]) {
   print "$ARGV[1]\n";
   $n++;
}
