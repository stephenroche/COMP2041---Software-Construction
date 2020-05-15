#!/usr/bin/perl -w

$string = $ARGV[0];
#print "$string\n\n";

print "#!/usr/bin/env python3\n\n";

$string =~ s/\\/\\\\/g;
$string =~ s/'/\\'/g;
$string =~ s/\n/\\n/g;

print "print(\'$string\')\n";
