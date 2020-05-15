#!/usr/bin/perl -w

foreach $course (@ARGV) {
   #print "$course\n";

   $url = "http://timetable.unsw.edu.au/2017/".$course.".html";

   #print "$url\n";
   open PAGE, "wget -q -O- $url|" or die;
   @lines = <PAGE>;

   #print "@lines\n";

   foreach $line (@lines) {
      if ($line =~ />Lecture<\/a><\/td>/) {
         $findTimes = 1;
         #print "$line";
      } elsif ($findTimes && $line =~ /web/i) {
         $findTimes = 0;
      } elsif ($findTimes && $line =~ />([A-Z])(\d)<\/a>/) {
         if ($1 ne "T") {
            $findTimes = 0;
         }
         $sem = "S$2";
      } elsif ($findTimes && $line =~ /week/i) {
         $findTimes = 0;
         #print $line;
         $times = $line;
         $times =~ s/.*>(.+)<.*/$1/;
         $toPrint = "$course: $sem $times";
         if (!$seen{$toPrint}) {
            $seen{$toPrint} = 1;
            print "$toPrint";
         }
      }
   }
}
