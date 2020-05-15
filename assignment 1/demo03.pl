#!/usr/bin/perl
use POSIX;
unshift(@ARGV, $0);
 # put your demo script here

 # Sorts arguments lexicographically



splice(@ARGV, 0, 1);
@sortedArgs = ();

while (scalar(@ARGV) > 0) {
   $next =  - 1;
   foreach $i ((0..scalar(@ARGV) - 1)) {
      if ($next ==  - 1 or $ARGV[$i] lt $ARGV[$next]) {
         ;  # String comparison
         $next = $i;

      }
   }
       # Add the next 'smallest' argument to the sorted list
   push(@sortedArgs, splice(@ARGV, $next, 1));  # Nested functions, pop() with argument

}
print 'Lexicographically sorted arguments:', "\n";  # Raw strings

print join(', ', @sortedArgs), "\n";  # Raw string, .join()
