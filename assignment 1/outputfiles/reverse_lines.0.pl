#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);

 # written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
 # Print line from stdin in reverse order



@lines = ();
foreach $line (<STDIN>) {
   push(@lines, $line);

}
$i = scalar(@lines) - 1;
while ($i >= 0) {
   print $lines[$i];
   $i = $i - 1;
}
