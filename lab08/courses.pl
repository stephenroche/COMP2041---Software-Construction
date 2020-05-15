#!/usr/bin/perl -w

$course = $ARGV[0];

$url = "http://timetable.unsw.edu.au/2017/".$course."KENS.html";

#print "$url\n";

open PAGE, "wget -q -O- $url|" or die;

@lines = <PAGE>;

foreach $line (@lines) {
   if ($line =~ /($course\d{4})/ && !$seen{$1}) {
      $seen{$1}++;
      print "$1\n";
   }
}
