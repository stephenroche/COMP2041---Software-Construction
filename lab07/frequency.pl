#!/usr/bin/perl -w

$target = lc $ARGV[0];

foreach $file (glob "lyrics/*.txt") {
   open F, "< $file" or die;

   $name = ($file =~ /lyrics\/(.*)\.txt/)[0];
   $name =~ tr/_/ /;
   #print "$name\n"

   $count{$name} = 0;
   $nWords{$name} = 0;

   while ($line = <F>) {
      @words = split(/[^a-z]+/i, lc $line);
      foreach $word (@words) {
         $count{$name}++ if ($word eq $target);
         $nWords{$name}++ if $word;
      }
   }

   printf("%4d/%6d = %.9f %s\n", $count{$name}, $nWords{$name}, $count{$name}/$nWords{$name}, $name);
}
