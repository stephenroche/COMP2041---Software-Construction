#!/usr/bin/perl -w

open F, "<$ARGV[1]" or die;

@lines = <F>;

if (@lines >= $ARGV[0] && $ARGV[0] > 0) {
   print "$lines[$ARGV[0]-1]";
}
