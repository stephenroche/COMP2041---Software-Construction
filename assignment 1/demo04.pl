#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # put your demo script here

 # Echos back whatever you type



@text = ();

foreach $line (<STDIN>) {
   ;  # Iterates over sys.stdin
   @words = split(/ /, $line);  # Implemented .split();
   $words = join(' ', @words);  # Words variable changed from a list to a string;
   push @text, $words;  # List concatenation

}
$toPrint = join("", @text);  # .join();

print sprintf("You wrote:\n--Start--\n%s--End--\n", $toPrint);
