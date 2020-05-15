#!/usr/bin/perl -w

open F, "< $ARGV[0]" or die;

@lines = <F>;
$size = @lines;

if ($size == 0) {
   exit;
} elsif ($size % 2 == 1) {
   print "$lines[($size - 1)/2]";
} else {
   print "$lines[$size/2 - 1]$lines[$size/2]";  
}
