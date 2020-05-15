#!/usr/bin/perl -w

#$whale = $ARGV[0];
#$nPods = 0;
#$nIndv = 0;

while ($line = <STDIN>) {
   chomp $line;
   $whale = $line;
   $whale =~ tr/A-Z/a-z/;
   $whale =~ s/[0-9]+ +//;
   $whale =~ s/s? *$//;
   $whale =~ s/ +/ /g;
   $nInPod = $line;
   $nInPod =~ s/ .*//;

   $nPods{$whale}++;
   $nIndv{$whale} += $nInPod;
}

foreach $whale (sort keys %nPods) {
   print "$whale observations: $nPods{$whale} pods, $nIndv{$whale} individuals\n"
}
