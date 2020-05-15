#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

$count = 0;
foreach $i ((2..100 - 1)) {
   $k = POSIX::floor($i/2);
   foreach $j ((2..$k + 1 - 1)) {
      $k = $i % $j;
      if ($k == 0) {
         $count = $count - 1;
         last;
      }
      $k = POSIX::floor($i/2);
   }
   $count = $count + 1;
}
print $count, "\n";
