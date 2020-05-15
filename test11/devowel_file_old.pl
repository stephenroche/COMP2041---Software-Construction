#!/usr/bin/perl

open(FILE, '<', $ARGV[0]);

while ($line = <FILE>) {
   $line =~ s/[aeiou]//gi;
   push @lines, $line;
}

close FILE;

open(FILE, '>', $ARGV[0]);

print FILE join('', @lines);
