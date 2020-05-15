#!/usr/bin/perl -w

open F, "< $ARGV[0]" or die;

@lines = <F>;

exit if (!@lines);

if (@lines % 2 == 0) {
   print "$lines[@lines/2-1]$lines[@lines/2]";
} else {
   print "$lines[@lines/2]";
}
