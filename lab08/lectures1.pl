#!/usr/bin/perl

if ($ARGV[0] eq '-d' || $ARGV[0] eq '-t') {
   $style = shift @ARGV;
}

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
         ($sem, $classNum, $section, $status, $enrols, $times) = ($lecture =~ /(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>).*?(<td.*?<\/td>)/);

         #print "sem = $sem\ntimes = $times\n\n\n";

         next if !($sem =~ /T([12])<\/a><\/td>/);
         $sem = "S$1";
         if ($times =~ />(.*Weeks.*)<\/td>/i) {
            $times = $1;
            $times =~ s/^\s*(.*?)\s*$/$1/;

            if(!$seen{$sem}{$course}{$times}) {
               $seen{$sem}{$course}{$times}++;
               print "$course: $sem $times\n" if !$style;

               @classes = ($times =~ /\w\w\w \d\d:\d\d - \d\d:\d\d/g);

               foreach $class (@classes) {
                  #print "class = $class\n";
                  ($day, $start, $finish) = ($class =~ /(\w\w\w) 0?(\d+):\d\d - 0?(\d+):\d\d/);
                  #print "day = $day; start = $start; finish = $finish\n";
                  while ($start < $finish) {
                     print "$sem $course $day $start\n" if ($style eq '-d' && !$entry{$sem}{$course}{$day}{$start});
                     $entry{$sem}{$course}{$day}{$start} = 1;
                     $start++;
                  }
               }
            }
         } else {
            $times = '';
         }

         #print "sem = $sem\ntimes = $times\n\n\n";
      }
   }
}   
