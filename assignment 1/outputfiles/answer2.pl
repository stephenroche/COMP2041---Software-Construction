#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

$answer = 1 + 7 * 7 - 8;
print $answer, "\n";
