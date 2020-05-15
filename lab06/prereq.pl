#!/usr/bin/perl -w

$urlU = "http://www.handbook.unsw.edu.au/undergraduate/courses/current/$ARGV[0].html";
$urlP = "http://www.handbook.unsw.edu.au/postgraduate/courses/current/$ARGV[0].html";

open uF, "wget -q -O- $urlU|" or die;
open pF, "wget -q -O- $urlP|" or die;

@lines = <uF>;
push @lines, <pF>;

#print @lines;

foreach $line (@lines) {
   if ($line =~ /<p>Pre(r| R)eq(uisites?|s?): /) {
      $line =~ s/<\/p>.*//;
      while ($line =~ /([A-Z]{4}[0-9]{4})/) {
         #print "$1\n";
         $prereqs{$1} = 1;
         $line =~ s/[A-Z]{4}[0-9]{4}//
      }
   }
}

for $course (sort keys %prereqs) {
   print "$course\n";
}
