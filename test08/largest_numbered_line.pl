#!/usr/bin/perl -w

while ($line = <STDIN>) {
   @line_nums = $line =~ /\-?\d*(?:\d|\.\d+)/g;
   $max_line_num = (sort {$b <=> $a} @line_nums)[0];
   if (@line_nums) {
      push @nums, $max_line_num;
      push @lines, $line;
   }
}

if (@nums) {
   $max = (sort {$b <=> $a} @nums)[0];
   foreach $i (0..$#nums) {
      if ($nums[$i] == $max) {
         print $lines[$i];
      }
   }
}
