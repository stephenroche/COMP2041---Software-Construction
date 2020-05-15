#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # writen by andrewt@cse.unsw.edu.au as a COMP2041 example
 # Python implementation of /bin/echo

print join(" ", @ARGV[1..$#ARGV]), "\n";
