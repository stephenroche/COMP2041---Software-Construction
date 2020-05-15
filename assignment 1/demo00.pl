#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # put your demo script here

 # examples/5/echo.2.py writen by andrewt@cse.unsw.edu.au
 # Python implementation of /bin/echo



print join(" ", @ARGV[1..$#ARGV]), "\n";  # .join(), sys.argv and open array ranges
