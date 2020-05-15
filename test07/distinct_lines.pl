#!/usr/bin/perl -w

while ($line = <STDIN>) {
   $key = lc $line;
   $key =~ s/\s+//g;
   
   if (!$seen{$key}) {
      $seen{$key} = 1;
   }
   $nlines++;
   
   if (keys %seen >= $ARGV[0]) {
      print "$ARGV[0] distinct lines seen after $nlines lines read.\n";
      exit;
   }
}

print "End of input reached after $nlines lines read - $ARGV[0] different lines not seen.\n";
