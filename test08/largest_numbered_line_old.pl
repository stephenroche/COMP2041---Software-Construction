#!/usr/bin/perl -w

$i = 0;

while ($line = <STDIN>) {
   push @numbers, $1 while $line =~ /(-?\d*(\d|\.\d+))/g;
   foreach $num (@numbers) {
      $max = $num if (!defined $max || $num > $max);
   }

   if (defined $max) {
      $maxOfLine{$line} = $max;
      $order{$line} = $i++;
   }
   undef @numbers;
   undef $max;
}

for $line (keys %maxOfLine) {
   $max = $maxOfLine{$line} if (!defined $max || $maxOfLine{$line} > $max);
}

for $line (sort {$order{$a} > $order{$b}} keys %maxOfLine) {
   print "$line" if ($maxOfLine{$line} == $max);
}
