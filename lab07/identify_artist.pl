#!/usr/bin/perl -w

foreach $file (glob "lyrics/*.txt") {
   open F, "< $file" or die;

   $name = ($file =~ /lyrics\/(.*)\.txt/)[0];
   $name =~ tr/_/ /;

   while ($line = <F>) {
      @words = split(/[^a-z]+/i, lc $line);
      foreach $word (@words) {
         if ($word) {
            $count{$name}{$word}++;
            $nWords{$name}++ ;
         }
      }
   }
   close F;

   foreach $word (keys %{$count{$name}}) {
      $logProb{$name}{$word} = log(($count{$name}{$word}+1)/$nWords{$name});
   }

   #print "$logProb{$name}{'fear'}\n";
}

foreach $song (@ARGV) {
   open F, "< $song" or die;

   foreach $name (keys %count) {
      $totProb{$name} = 0;
   }

   while ($line = <F>) {
      @words = split(/[^a-z]+/i, lc $line);
      foreach $word (@words) {
         foreach $name (keys %logProb) {
            if (exists $logProb{$name}{$word}) {
               $totProb{$name} += $logProb{$name}{$word};
            } else {
               $totProb{$name} += log(1/$nWords{$name});
            }
         }
      }
   }
   close F;

   foreach $name (keys %totProb) {
      #print "$song: log_probability of $totProb{$name} for $name\n";

      $best = $name if (!$best || $totProb{$name} > $totProb{$best});
   }

   printf("%s most resembles the work of %s (log-probability=%.1f)\n", $song, $best, $totProb{$best});
}
