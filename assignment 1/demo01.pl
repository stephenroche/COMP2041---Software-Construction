#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # put your demo script here

 # has to be run as $ ./pypl.pl demo01.py > demo01.pl
 #                  $ perl demo01.pl

 # Performs and prints various calculations involving two numbers



print "Enter x:", "\nx = ";
$x = (<STDIN>);  # implemented float();
print "Enter y:", "\ny = ";
$y = (<STDIN>);

%calcs = ();
$calcs{"sum"} = $x + $y;
$calcs{"product"} = $x * $y;
$calcs{"power"} = $x**$y;
$calcs{"floor division"} = POSIX::floor($x/$y);  # floor division (works with negatives);
$calcs{"sum of squares"} = $x**2 + $y**2;

print sprintf("There are %d calculations:", scalar(keys %calcs)), "\n";
 # string formatting with nested len() and .keys() functions

foreach $key (sort keys %calcs) {
   ;  # sorted(), multiline for loops
   print sprintf("The %14s of %.2f and %.2f is %8.2f", $key, $x, $y, $calcs{$key}), "\n";
}
 # more complex string formatting and accessing hash values
