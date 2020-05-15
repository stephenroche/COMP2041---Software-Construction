#!/usr/bin/perl -w

for $line (<STDIN>) {
   @words = split /\s+/, $line;
   $line = join ' ', sort @words;
   print "$line\n";
}
