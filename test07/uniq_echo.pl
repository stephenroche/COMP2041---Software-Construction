#!/usr/bin/perl -w

$i = 1;

foreach $arg (@ARGV) {
   if (!$seen{$arg}) {
      $seen{$arg} = $i++;
   }
}

for $arg (sort {$seen{$a} <=> $seen{$b}} keys %seen) {
   push @args, $arg;
}

print join ' ', @args;
print "\n";
