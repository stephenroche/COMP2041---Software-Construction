#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

foreach $i ((0..5 - 1)) {
   print $i, "\n";
}
