#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

$factor0 = 6;
$factor1 = 7;
$answer = $factor0 * $factor1;
print $answer, "\n";
