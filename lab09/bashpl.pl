#!/usr/bin/perl -w

open F, "< $ARGV[0]" or die;

@lines = <F>;

foreach $line (@lines) {
   #print $line;
   $line =~ s/[\s\n]*$//;

   if ($line =~ /^#!/) {
      print "#!/usr/bin/perl\n";
      next;
   }

   if ($line =~ /(.*?)(#(.*))/) {
      $line = $1;
      $comment = "$2\n";
   } else {
      $comment = '';
   }

   if ($line =~ /(\s*while)(.*)/) {
      $start = $1;
      $end = $2;
      $end =~ s/([a-z]\w*)/\$$1/g;
      print "$start$end\n";
   } elsif ($line =~ /^(\s*)do$/) {
      print "$1\{\n";
   } elsif ($line =~ /^(\s*)done$/) {
      print "$1\}\n";

   } elsif ($line =~ /(\s*if)(.*)/) {
      $start = $1;
      $end = $2;
      $end =~ s/([a-z]\w*)/\$$1/g;
      print "$start$end\n";



   } elsif ($line =~ /(.*)else/) {
      $start = $1;
      print "$start} else {\n";



   } elsif ($line =~ /^(\s*)then$/) {
      print "$1\{\n";
   } elsif ($line =~ /^(\s*)fi$/) {
      print "$1\}\n";
   
   } elsif ($line =~ /(\s*)(echo\s*)(.*)/) {
      $start = $1;
      $end = $3;
      print "$start", "print ", "\"$end\\n\";\n";
   } else {
      $line =~ s/\$//g;
      $line =~ s/([a-z]\w*)/\$$1/ig;

      if (not $line =~ /^\s*$/) {
         print "$line;\n";
      }
   }

   print "$comment";
}
