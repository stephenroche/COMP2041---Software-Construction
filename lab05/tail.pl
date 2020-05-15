#!/usr/bin/perl -w

$n = 10;

if (@ARGV && $ARGV[0] =~ /^-[0-9]+$/) {
   $n = $ARGV[0];
   $n =~ s/-//;
   shift @ARGV;
}

#print "$n\n";


if (@ARGV) {
   foreach $file (@ARGV) {
      open F, '<', $file or die "$0: Can't open $file: $!\n";
      if ($#ARGV > 0) {
         print "==> $file <==\n";
      }
      @lines = ();
      while ($line = <F>) {
         push @lines, $line;
      }
      $start = $#lines-$n+1;
      if ($start < 0) {
         $start = 0;
      }
      print @lines[$start..$#lines];

      close F
   }

} else {
   @lines = ();
   while ($line = <STDIN>) {
      push @lines, $line;
   }

   $start = $#lines-$n+1;
   if ($start < 0) {
      $start = 0;
   }
   print @lines[$start..$#lines];
}
