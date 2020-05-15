#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

print "Enter a number: ";
$a = int(<STDIN>);
if ($a < 0) {
   print "negative", "\n";
}
elsif ($a == 0) {
   print "zero", "\n";
}
elsif ($a < 10) {
   print "small", "\n";
}
else {
   print "large", "\n";
}
