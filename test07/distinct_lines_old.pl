#!/usr/bin/perl -w

$max = $ARGV[0];
$nDistinct = 0;
$nRead = 0;

while ($line = <STDIN>) {
   $line = lc $line;
   $line =~ s/\s//g;
   #print "$line\n";

   if (!$seen{$line}) {
      $seen{$line}++;
      $nDistinct++;
   }
   $nRead++;

   if ($nDistinct >= $max) {
      print "$nDistinct distinct lines seen after $nRead lines read.\n";
      exit;
   }
}

print "End of input reached after $nRead lines read - $max different lines not seen.\n";
