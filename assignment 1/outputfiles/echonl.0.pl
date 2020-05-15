#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

foreach $arg (@ARGV[1..$#ARGV]) {
   print $arg, "\n";
}
