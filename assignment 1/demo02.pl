#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # put your demo script here

 # Adapted from exponential_concatenation.py (writen by andrewt@cse.unsw.edu.au)
 # Creates a string of size 2^n by concatenation



if (scalar(@ARGV) != 3) {
   print sprintf("Usage: %s <string> <n>\n", $ARGV[0]);  # accessing the name of the program (sys.argv[0]);
   exit;
}
$n = 0;
$string = $ARGV[1];

while ($n < int($ARGV[2])) {
   $string = $string x 2;  # string multiplication;
   $n += 1;

}
print sprintf("String of 2^%d = %d %s's created:\n", $n, length($string) / length($ARGV[1]), $ARGV[1]), "\n";  # functions within string formatting
print $string, "\n";
