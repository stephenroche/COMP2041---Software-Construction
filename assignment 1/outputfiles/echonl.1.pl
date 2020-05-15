#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

foreach $i ((1..scalar(@ARGV) - 1)) {
   print $ARGV[$i], "\n";
}
