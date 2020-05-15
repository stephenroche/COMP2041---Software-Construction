#!/usr/bin/perl -w

open F, "< $ARGV[1]" or die;

@lines = <F>;

if ($ARGV[0] > 0 && $ARGV[0] <= scalar @lines) {
   print $lines[$ARGV[0] - 1];
}
