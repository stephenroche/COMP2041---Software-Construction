#!/usr/bin/perl -w

if ($ARGV[0] eq '-r') {
   $recursive = 1;
   shift @ARGV;
}

push @queue, $ARGV[0];

while ($curr = shift @queue) {
   #print "---Scraping $curr---\n";

   $urlU = "http://www.handbook.unsw.edu.au/undergraduate/courses/current/$curr.html";
   $urlP = "http://www.handbook.unsw.edu.au/postgraduate/courses/current/$curr.html";

   open uF, "wget -q -O- $urlU|" or die;
   open pF, "wget -q -O- $urlP|" or die;

   @lines = <uF>;
   push @lines, <pF>;

   close uF;
   close pF;

   #print @lines;

   foreach $line (@lines) {
      if ($line =~ /<p>Pre(r| R)eq(uisite)?s?: /) {
         $line =~ s/<\/p>.*//;
         while ($line =~ /([A-Z]{4}[0-9]{4})/) {
            #print "$1\n";
            $prereqs{$1} = 1;
            if ($recursive) {
               push @queue, $1;
            }
            $line =~ s/[A-Z]{4}[0-9]{4}//
         }
      }
   }
}

for $course (sort keys %prereqs) {
   print "$course\n";
}
