#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);


$number = 0;
while ($number >= 0) {
   print "> ";
   $number = int(<STDIN>);
   if ($number >= 0) {
      if ($number % 2 == 0) {
         print "Even", "\n";
      }
      else {
         print "Odd", "\n";
      }
   }
}
print "Bye", "\n";

