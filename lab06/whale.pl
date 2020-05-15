#!/usr/bin/perl -w

$whale = $ARGV[0];
$nPods = 0;
$nIndv = 0;

while ($line = <STDIN>) {
   if ($line =~ /$whale/) {
      $nPods++;
      $line =~ s/ .*//;
      $nIndv += $line;
   }
}

print "$whale observations: $nPods pods, $nIndv individuals\n"
