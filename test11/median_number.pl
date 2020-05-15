#!/usr/bin/perl

@sorted = sort { $a <=> $b } @ARGV;

print "$sorted[@sorted/2]\n";
