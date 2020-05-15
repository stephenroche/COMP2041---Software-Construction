#!/usr/bin/perl -w

while ($line = <STDIN>) {
   $line =~ s/[0-9]//g;
   print "$line";
}
