#!/usr/bin/perl -w

for $line (<STDIN>) {
   $line =~ s/[0-9]//g;
   print $line;
}
