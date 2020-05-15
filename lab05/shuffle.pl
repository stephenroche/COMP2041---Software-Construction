#!/usr/bin/perl -w

@lines = ();

while ($line = <STDIN>) {
   push @lines, $line;
}

$length = $#lines + 1;

while ($length > 0) {
   $n = int(rand($length));

   print $lines[$n];
   @lines = (@lines[0..$n-1], @lines[$n+1..$#lines]);

   $length--;
}
