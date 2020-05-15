#!/usr/bin/perl -w

while ($line = <STDIN>) {
   $nChars = length $line;
   $newLine="";
   $i = 0;

   while ($i < $nChars) {
      $ch = substr($line,$i++,1);
      if ($ch =~ /^[0-4]$/) {
         $ch="<";
      } elsif ($ch =~ /^[6-9]$/) {
         $ch=">";
      }
      $newLine=$newLine.$ch;
   }

   print "$newLine";
}
