#!/usr/bin/perl -w

use strict;

sub fn {
   my ($a, $b) = @_;
   my $c = $a + $b;
   my $d = $a * $b;
   my $e = $a ** $b;
   
   my @ret = ($c, $d, $e);

   #return @ret;
   return ($c, $d, $e);
}

sub retHash {
   my ($a, $b) = @_;
   my $c = $a + $b;
   my $d = $a * $b;
   my $e = $a ** $b;
   
   return (sum => $c, mult => $d, pow => $e);
}

my @array = fn(3, 4);
my ($c, $d) = fn(5, 6);

print "'@array'\n";
print "$c $d\n";

my $e = fn(7,8);
print "$e\n";

my @f = fn(7,8);
print "$f[1]\n";

my %g = retHash(7,8);
my $h = $g{sum};
print "$h\n";

my $ind = '   ';
my $line = '      command;';

$line =~ s/($ind){2}/?/g;

print "$line\n";

my $var = '[a-zA-Z_]\w*';
my $string = " 42var_One1+2 #comment ";
$string =~ /\s*($var)(.*)/;
print "var = '$1', rest = '$2'\n";

my $ans = 5 ** 3;
print "$ans\n";

#my $i = test;
#print "$i\n";

use POSIX;
my $j = POSIX::floor(5/2);
print "$j\n";

print '', "\n";
print '\n', "dollar\$dollar", "\n";

#$a = int (<STDIN>);
#print "$a\n";

my $var1 = 4;
my $var2 = 5;
my @arr = (3,4,5,6,7);
my %hash = (apple => 'red');
print("$var1,@arr,%hash\n");
printf("$var1 %d\n", $var2);

unshift(@ARGV, $0);
print ("@ARGV\n");

print "@arr[1..3]\n";

$a = int(3.5);
print "$a\n";

$b = splice(@arr, 2, 1);
print "@arr, $b\n";

$c = scalar(@arr);
print "$c\n";

my $str = "hello\n";
$d = length($str);
print "$d\n";
$e = substr($str, 0, 1);
print "$e\n";

my %hash2 = ();

my $number = 4/7;
print(sprintf("%.3f, %04d", $number, $d), "\n");

my @arr1 = (1,2,3);
my @arr2 = (4,5);
my @arr3 = (@arr1, @arr2);
print "@arr1; @arr2; @arr3\n";

#foreach $line (<>) {
#   print "**$line";
#}




print "Enter x:", "\nx = ";
my $x = (<STDIN>);
print "Enter y:", "\ny = ";
my $y = (<STDIN>);

my %calcs = ();
$calcs{"sum"} = $x + $y;
$calcs{"product"} = $x * $y;
$calcs{"power"} = $x**$y;
$calcs{"floor division"} = POSIX::floor($x/$y);

foreach my $key (sort keys %calcs) {
   print sprintf("The %s of %.3f and %.3f is %6.3f", $key, $x, $y, $calcs{$key}), "\n";
}



