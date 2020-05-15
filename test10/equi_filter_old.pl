#!/usr/bin/perl

while ($line = <STDIN>) {
   @words = split /\s+/, $line;
   undef @out;

   foreach $word (@words) {
      undef %count;
      $lword = lc $word;

      foreach $i (0..(length $lword) - 1) {
         $letter = substr($lword, $i, 1);
         $count{$letter}++;
      }

      $n = -1;
      $print = 1;
      foreach $letter (keys %count) {
         if ($n == -1) {
            $n = $count{$letter};
         } elsif ($count{$letter} != $n) {
            $print = 0;
         }
      }

      if ($print) {
         push @out, $word;
      }
   }

   print join(' ', @out);
   print "\n";
}
