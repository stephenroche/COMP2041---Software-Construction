#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

$x = 1;
while ($x < 10) {
   $y = 1;
   while ($y <= $x) {
      print "*";
      $y = $y + 1;
   }
   print "\n";
   $x = $x + 1;
}
