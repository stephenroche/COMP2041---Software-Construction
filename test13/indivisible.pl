#!/usr/bin/perl

foreach $line (<STDIN>) {
	@nums = split /\D+/, $line;
	foreach $num (@nums) {
		if ($num ne '') {
			if ($numbers{$num}) {
				$numbers{$num} = 0;
			} else {
				$numbers{$num} = 1;
			}
		} else {
			#print "*";
		}
	}
}

foreach $num (keys %numbers) {
	foreach $num2 (keys %numbers) {
		if ($num != $num2 && $num % $num2 == 0) {
			$numbers{$num} = 0;
		}
	}
	#print "$num: $numbers{$num}\n";
}

foreach $num (sort {$a <=> $b} keys %numbers) {
	if ($numbers{$num}) {
		push @toPrint, $num;
	}
}

print join ' ', @toPrint;
print "\n";
