#!/usr/bin/perl

foreach $course (@ARGV) {
   $url = "http://timetable.unsw.edu.au/2017/".$course.".html";

   open PAGE, "wget -q -O- $url|" or die;
   @allLines = <PAGE>;
   $lines = join('', @allLines);
   $lines =~ s/\s+/ /g;

   @tables = ($lines =~ /Day\/Start.*?<\/table/ig);
   #print "@tables\n";
   #print scalar(@tables);

   foreach $table (@tables) {
      @lectures = ($table =~ /Lecture<\/a><\/td>.*?<\/tr>/ig);
      #print join('\n----------------\n',@lectures);
      foreach $lecture (@lectures) {
         ($sem, $class, $section, $status, $enrols, $times) = ($lecture =~ /(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>)/);

         #print "sem = $sem\ntimes = $times\n\n\n";

         $sem =~ /T([12])<\/a><\/td>/;
         $sem = "S$1";
         if ($times =~ />(.*Weeks.*)<\/td>/i) {
            $times = $1;
            $times =~ s/^\s*(.*?)\s*$/$1/;

            if(!$seen{$course}{$sem}{$times}) {
               $seen{$course}{$sem}{$times}++;
               print "$course: $sem $times\n";
            }
         } else {
            $times = '';
         }

         #print "sem = $sem\ntimes = $times\n\n\n";
      }
   }
}   
