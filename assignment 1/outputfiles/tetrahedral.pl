#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

$n = 1;
while ($n <= 10) {
   $total = 0;
   $j = 1;
   while ($j <= $n) {
      $i = 1;
      while ($i <= $j) {
         $total = $total + $i;
         $i = $i + 1;
      }
      $j = $j + 1;
   }
   print $total, "\n";
   $n = $n + 1;
}
