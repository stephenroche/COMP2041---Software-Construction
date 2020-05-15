#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
 # Count the number of lines on standard input.



@lines = <STDIN>;
$line_count = scalar(@lines);
print sprintf("%d lines", $line_count), "\n";
