#!/usr/bin/perl

foreach $line (<STDIN>) {
   @words = split /\s+/, $line;
   undef @toPrint;
   
   #print join ' ', @words;
   
   foreach $word (@words) {
      $lword = lc $word;
      undef %count;
      
      for $i (0..length($lword) - 1) {
         $char = substr($lword, $i, 1);
         $count{$char}++;
         $n = $count{$char};
      }
      
      #print "word = $lword, n = $n\n";
      #print %count, "\n";
      undef $not_equi;
      
      for $char (keys %count) {
         if ($count{$char} != $n) {
            $not_equi = 1;
         }
      }
      
      if (!$not_equi) {
         push @toPrint, $word;
      }
   }
   
   print join(' ', @toPrint), "\n";
}
