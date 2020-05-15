#!/usr/bin/perl -w

# COMP2041 Assignment 1
# http://www.cse.unsw.edu.au/~cs2041/assignments/pypl
# Written by Stephen Roche September 2017

use strict;

# Variables used for regex matching
our $var = '[a-zA-Z_]\w*';
our $num = '-?\d+(?:\.\d+)?';

# %types hash keeps track of variable types
our %types = (ARGV => '@');

# $tabs keeps track of the current indent level in the Python code
our $tabs = 0;
our $ind = "";
our $spaces = "   ";

# Convert line - main function used to convert an entire line or subsection of line into Perl code
# Works by iterating through the line one (or a few) terms at at time, trying to match the next term
# Remainder of line is stored in $rest
# All functions return a %ret hash, that contains different pieces of returned information
sub cline {
   my ($line) = @_;
   my $end = 0;
   my $conv = ''; # The converted Perl line
   my $rest = $line;
   my $varType = '?'; # If line is used as assignment, what type should it be
   my $endType = 'none'; # e.g. command, start of loop, comment
   my (%ret, $varName, $blockInd, $sym);

   while (!$end) {
      # Replace sys.argv with ARGV
      $rest =~ s/^\s*sys\.argv/ARGV/;

      # Comments
      if ($rest =~ /^(\s*#.*)/) {
         $rest = '';
         $end = 1;
         # Add a semicolon if it follows a command
         if ($endType ne 'colon' && $endType ne 'none') {
            $conv .= ';';
         }
         if ($endType ne '?') {
            $conv .= ' ';
         }
         $conv .= "$1";
         $endType = 'comment';

      # Import
      } if ($rest =~ /^\s*import /) {
         # Ignore the line
         $rest = '';
         $end = 1;
         $endType = 'comment';

      # Trailing whitespace
      } elsif ($rest =~ /^\s*$/) {
         $rest = '';
         $end = 1;

      # Quoted strings
      } elsif ($rest =~ /^\s*(["'])(.*)/) {
         %ret = cstring($2, $1);
         $rest = $ret{rest};
         my $string = $ret{conv};

         # join() method
         if ($rest =~ /^.join\((.*)/) {
            $rest = $1;
            %ret = cline($rest);
            $rest = $ret{rest};
            $conv .= "join($string, $ret{conv})";
         } else {
            $conv .= $string;
         }

         $varType = '$s'; # $s = scalar, string
         $endType = 'command';

      # Raw strings
      } elsif ($rest =~ /^\s*r'(.*)/) {
         %ret = craw($1);
         $rest = $ret{rest};
         my $string = $ret{conv};

         # join() method
         if ($rest =~ /^.join\((.*)/) {
            $rest = $1;
            %ret = cline($rest);
            $rest = $ret{rest};
            $conv .= "join($string, $ret{conv})";
         } else {
            $conv .= $string;
         }

         $varType = '$s';
         $endType = 'command';

      # Open grouping brackets
      } elsif ($rest =~ /^\s*\((.*)/) {
         %ret = cline($1);
         $rest = $ret{rest};
         $varType = $ret{varType};
         $conv .= "($ret{conv})";

      # Open square brackets (array assignment)
      } elsif ($rest =~ /^\s*\[(.*)/) {
         my @elems = getArgs($1);
         $rest = shift @elems;

         my $allElems = join(', ', @elems);
         $conv .= "($allElems)";

         $varType = '@';
         $endType = 'command';

      # Open curly brackets (hash assignment)
      } elsif ($rest =~ /^\s*\{(.*)/) {
         $rest = $1;
         $conv .= "()";
         $varType = '%';
         $endType = 'command';

      # Close brackets
      } elsif ($rest =~ /^\s*[)}\]](.*)/) {
         $rest = $1;
         # Return from subline
         $end = 1;
         $endType = 'command';

      # Close if/while/for
      } elsif ($rest =~ /^\s*:(.*)/) {
         $rest = $1;
         $end = 1;
         $endType = 'colon';

      # Semicolon separator
      } elsif ($rest =~ /^\s*;(.*)/) {
         $rest = $1;
         $end = 1;
         $endType = 'command';

      # Comma separator
      } elsif ($rest =~ /^\s*,(.*)/) {
         $rest = $1;
         $end = 1;
         $endType = 'comma';

      # if/elif statements, while loops
      } elsif ($rest =~ /^\s*(if|elif|while)(.*)/) {
         $tabs++;
         my $ifWhile = $1;
         $ifWhile = 'elsif' if ($ifWhile eq 'elif');
         %ret = cline($2);
         $rest = $ret{rest};
         $conv .= "$ifWhile ($ret{conv}) {";
         $endType = 'colon';

         if (!$rest =~ /^\s*$/) {
            # Add the appropriate indent
            $blockInd = "$spaces" x $tabs;
            $conv .= "\n$blockInd";
            $endType = 'command';
         }

      # else statement
      } elsif ($rest =~ /^\s*else:(.*)/) {
         $tabs++;
         $rest = $1;
         $conv .= "else {";
         $endType = 'colon';

         if (!$rest =~ /^\s*$/) {
            # Add the appropriate indent
            $blockInd = "$spaces" x $tabs;
            $conv .= "\n$blockInd";
            $endType = 'command';
         }

      # for loops
      } elsif ($rest =~ /^\s*for\s+($var)\s+in\s+(.*)/) {
         $tabs++;
         my $looper = $1;
         $rest = $2;
         $types{$looper} = '$n';
         # Assume looper is a number except in the following cases
         $types{$looper} = '$s' if ($rest =~ /^(sys\.|ARGV|lines|file|open|sort|string)/);
         %ret = cline($rest);
         $rest = $ret{rest};
         $conv .= "foreach \$$looper ($ret{conv}) {";
         $endType = 'colon';

         if (!$rest =~ /^\s*$/) {
            $blockInd = "$spaces" x $tabs;
            $conv .= "\n$blockInd";
            $endType = 'command';
         }

      # Bitwise operators
      } elsif ($rest =~ /^\s*(\||\^|&|<<|>>|~)(.*)/) {
         $rest = $2;
         $conv .= "$1";

      # Logical operators
      } elsif ($rest =~ /^\s*(not|or|and)(.*)/) {
         $rest = $2;
         $conv .= " $1 ";

      # Comparison operators
      } elsif ($rest =~ /^\s*(<[=>]?|>=?|[!=]=)(.*)/) {
         $rest = $2;
         if ($varType ne '$s') {
            $conv .= " $1 ";
         # Use string comparisons if the variables are strings
         } elsif ($1 eq '<') {
            $conv .= ' lt ';
         } elsif ($1 eq '<=') {
            $conv .= ' le ';
         } elsif ($1 eq '>') {
            $conv .= ' gt ';
         } elsif ($1 eq '>=') {
            $conv .= ' ge ';
         } elsif ($1 eq '==') {
            $conv .= ' eq ';
         } else {
            $conv .= ' ne ';
         }

      # Floor division
      } elsif ($rest =~ /^\s*($var|$num)\s*\/\/\s*($var|$num)(.*)/) {
         $rest = $3;
         my $first = $1;
         my $second = $2;
         if ($first =~ /$var/) {
            $first = "\$$first"
         }
         if ($second =~ /$var/) {
            $second = "\$$second"
         }
         $conv .= "POSIX::floor($first/$second)";
         $varType = '$n';
         $endType = 'command';

      # Array concatenation
      } elsif ($rest =~ /^\s*($var)\s*(\+=?)\s*($var)(.*)/ && $types{$1} eq '@') {
         $rest = $4;

         $sym = substr($types{$3}, 0, 1);

         if ($2 eq '+=') {
            $conv .= "push \@$1, $sym$3";
         } else {
            $conv .= "(\@$1, $sym$3)";
         }
         $varType = '@';
         $endType = 'command';

      # Exponentiation
      } elsif ($rest =~ /^\s*\*\*(.*)/) {
         $rest = $1;
         $conv .= "**";

      # Other numerical operators
      } elsif ($rest =~ /^\s*([+\-*\/%]=?)(.*)/) {
         $rest = $2;
         # When used with strings:
         if ($varType eq '$s' && $1 eq '+') {
            $conv .= ' . ';
         } elsif ($varType eq '$s' && $1 eq '+=') {
            $conv .= ' .= ';
         } elsif ($varType eq '$s' && $1 eq '*') {
            $conv .= ' x ';
         } else {
            $conv .= " $1 ";
         }

      # Numbers
      } elsif ($rest =~ /^\s*($num)(.*)/) {
         $rest = $2;
         $conv .= "$1";
         $varType = '$n';
         $endType = 'command';



      # Break
      } elsif ($rest =~ /^\s*break(.*)/) {
         $rest = $1;
         $conv .= "last";
         $endType = 'command';

      # Continue
      } elsif ($rest =~ /^\s*continue(.*)/) {
         $rest = $1;
         $conv .= "next";
         $endType = 'command';

      # range()
      } elsif ($rest =~ /^\s*range\((.*)/) {
         %ret = crange($1);
         $conv .= $ret{conv};
         $rest = $ret{rest};
         $varType = '@';
         $endType = 'command';

      # Print statements
      } elsif ($rest =~ /^\s*print\((.*)/) {
         %ret = cprint($1);
         $conv .= $ret{conv};
         $rest = $ret{rest};
         $varType = 'p?';
         $endType = 'command';

      # sys.stdout.write()
      } elsif ($rest =~ /^\s*sys\.stdout\.write\((.*)/) {
         %ret = cwrite($1);
         $conv .= $ret{conv};
         $rest = $ret{rest};
         $varType = 'w?';
         $endType = 'command';

      # sys.stdin.readline(s)
      } elsif ($rest =~ /^\s*sys\.stdin\.readline(s|)\(\)(.*)/) {
         $conv .= "<STDIN>";
         $rest = $2;
         # Perl <STDIN> var type depends on context
         if ($1 eq 's') {
            $varType = '@';
         } else {
            $varType = '$s';
         }
         $endType = 'command';

      # sys.stdin
      } elsif ($rest =~ /^\s*sys\.stdin(.*)/) {
         $conv .= "<STDIN>";
         $rest = $1;

      # sys.exit()
      } elsif ($rest =~ /^\s*sys\.exit\(/) {
         $conv .= "exit";
         $rest = '';
         $endType = 'command';

      # fileinput.input()
      } elsif ($rest =~ /^\s*fileinput\.input\(\)(.*)/) {
         $conv .= "<STDIN>"; #<> reads from itself?
         $rest = $1;

      # int()
      } elsif ($rest =~ /^\s*int\((.*)/) {
         %ret = cline($1);
         $rest = $ret{rest};
         $conv .= "int($ret{conv})";
         $varType = '$n';
         $endType = 'command';

      # float()
      } elsif ($rest =~ /^\s*float\((.*)/) {
         %ret = cline($1);
         $rest = $ret{rest};
         # Strings, ints and floats are all scalars in Perl
         $conv .= "($ret{conv})";
         $varType = '$n';
         $endType = 'command';

      # len()
      } elsif ($rest =~ /^\s*len\((.*)/) {
         %ret = cline($1);
         $rest = $ret{rest};
         if ($ret{varType} eq '@') {
            $conv .= "scalar($ret{conv})";
         } else {
            $conv .= "length($ret{conv})";            
         }
         $varType = '$n';

      # sorted()
      } elsif ($rest =~ /^\s*sorted\((.*)/) {
         %ret = cline($1);
         $rest = $ret{rest};
         $conv .= "sort $ret{conv}";
         $varType = '@';


      # Variables (including methods)
      } elsif ($rest =~ /^\s*($var)(.*)/) {
         $varName = $1;
         $rest = $2;
         my $suffix = ''; # Trailing [index] or {key} brackets

         # Hashes
         if ($rest =~ /^\[/ && $types{$varName} eq '%') {
            while ($rest =~ /^\[/) {
               $rest =~ s/^\[//;
               %ret = cline($rest);
               $rest = $ret{rest};
               $suffix .= "{$ret{conv}}";
            }
            $varType = '$n';

         # Arrays
         } elsif ($rest =~ /^(\[.*)/) {
            %ret = getIndices($1, $varName);
            $rest = $ret{rest};
            $varType = $ret{type};
            # ARGV contains strings
            $varType = '$s' if ($varName eq 'ARGV' && $varType ne '@');
            $suffix = $ret{conv};
            $types{$varName} = '@';

         # Plain variables (overridden on assignment)
         } elsif (exists $types{$varName}) {
            $varType = $types{$varName};
         }
         

         # Assignments
         if ($rest =~ /^\s*=([^=].*)/) {
            %ret = cline($1);
            $varType = $ret{varType};
            $rest = $ret{rest};
            $sym = substr($varType, 0, 1);
            $conv .= "$sym$varName$suffix = $ret{conv}";
            $types{$varName} = $varType if ($suffix eq '');

         # String.split()
         # Includes maxsplit parameter
         } elsif ($rest =~ /^\.split\((.*)/) {
            $types{$varName} = '$s';
            %ret = cline($1);
            $rest = $ret{rest};
            my $splitter = '\s+'; # Default splitter
            if ($ret{conv} ne '' && not $ret{conv} =~ /maxsplit/) {
               $splitter = $ret{conv};
               $splitter =~ s/^["'](.*)["']$/$1/;
            }

            my $maxSplit = -1;
            if ($ret{endType} eq 'comma') {
               %ret = cline($rest);
               $rest = $ret{rest};
            }

            if ($ret{conv} =~ /(\d+)$/) {
               $maxSplit = $1;
            }

            if ($maxSplit == -1) {
               $conv .= "split(/$splitter/, \$$varName)";
            } else {
               $conv .= "split(/$splitter/, \$$varName, $maxSplit+1)";
            }
            $varType = '@'

         # Array.append()
         } elsif ($rest =~ /^\.append\((.*)/) {
            %ret = cline($1);
            $rest = $ret{rest};
            $types{$varName} = '@';
            $conv .= "push(\@$varName, $ret{conv})";

         # Array.pop(opt. index)
         } elsif ($rest =~ /^\.pop\((.*)/) {
            %ret = cline($1);
            $rest = $ret{rest};
            $types{$varName} = '@';
            # No index given
            if ($ret{conv} eq '') {
               $conv .= "pop(\@$varName)";
            # Pop index given
            } else {
               $conv .= "splice(\@$varName, $ret{conv}, 1)";
            }
            $varType = '$n';

         # Hash.keys()
         } elsif ($rest =~ /^\.keys\(\)(.*)/) {
            $rest = $1;
            $types{$varName} = '%';
            $conv .= "keys \%$varName$suffix";
            $varType = '@';

         # Plain variable
         } else {
            $sym = substr($varType, 0, 1);
            $conv .= "$sym$varName$suffix";
         }

         $endType = 'command';

      # No match found for remainder of line
      } else {
         print "line not finished, '$rest' remaining\n";
         $end = 1;
      }
   }

   # $conv: converted Perl line
   # $rest: remainder of the Python line not yet converted
   # $varType: if line is used in an assignment, this is what type the variable would be
   # $endType: the type of the end of the line (e.g. comment, command, start of loop)
   return (conv => $conv, rest => $rest, varType => $varType, endType => $endType);
}





# Get array indices (including ':')
sub getIndices {
   my ($rest, $varName) = @_;
   my $conv = '';
   my $type;
   my %ret;

   # while loop works with multidimensional arrays
   while ($rest =~ /^\[/) {
      $rest =~ s/^\[//;
      %ret = cline($rest);
      $rest = $ret{rest};

      # Range within array
      if ($ret{endType} eq 'colon') {
         # Default lower bound if none given
         my $start = 0;
         if ($ret{conv} ne '') {
            $start = $ret{conv};
         }

         %ret = cline($rest);
         $rest = $ret{rest};

         # Default upper bound if none given
         my $end = "\$#$varName";
         if ($ret{conv} ne '') {
            $end = "$ret{conv}-1";
         }

         $type = '@';
         $conv .= "[$start..$end]";

      # Single element
      } else {
         $conv .= "[$ret{conv}]";
         $type = '$n';
      }
   }

   return (conv => $conv, rest => $rest, type => $type);
}


# Convert string (excludes raw strings)
sub cstring {
   my ($line, $q) = @_;

   # Find first non-escaped closing quote (must be same type as starting quote)
   $line =~ /((.*?[^\\])|^)((\\\\)*)$q(.*)/ or die "No closing quotes";

   my $conv = '"'."$1$3".'"';
   my $rest = $5;

   # Need to escape Perl special characters
   # Add two backslashes for an odd number of \'s before the variable, one otherwise
   $conv =~ s/([^\\]|^)(\\|)((\\\\)*)(\$|\@)/$1$2$2$3\\$5/g;

   # String formatting with %
   if ($rest =~ /^\s*\%(.*)/) {
      $rest = $1;

      my $allArgs;

      # Mulitple args
      if ($rest =~ /^\s*\((.*)/) {
         my @args = getArgs($1);
         $rest = shift @args;
         $allArgs = join(', ', @args);

      # One arg
      } else {
         my %ret = cline($rest);
         $rest = $ret{rest};
         $rest = ",$rest" if ($ret{endType} eq 'comma');
         $allArgs = $ret{conv};
      }

      $conv = "sprintf($conv, $allArgs)";
   }

   return (conv => $conv, rest => $rest);
}

# Convert raw string
sub craw {
   my ($line) = @_;

   # Find first non-escaped closing quote
   $line =~ /((.*?[^\\])|^)((\\\\)*)'(.*)/ or die "No closing quotes";

   my $conv = "'$1$3'";
   my $rest = $5;

   return (conv => $conv, rest => $rest);
}

# Convert print()
sub cprint {
   my ($line) = @_;
   
   my %ret = cline($line);
   my $toPrint = $ret{conv};
   my $rest = $ret{rest};

   # Default end parameter
   my $end = "\"\\n\"";

   # End parameter
   if ($ret{endType} eq 'comma' && $rest =~ /^\s*end\s*=\s*(["'])(.*)/) {
      %ret = cstring($2, $1);
      $rest = $ret{rest};
      $end = $ret{conv};
      # Don't bother printing ", ''"
      $end = '' if ($end eq '""' || $end eq "''");
   }

   if ($toPrint && $end) {
      $toPrint .= ', ';
   }

   my $conv = "print $toPrint$end";

   return (conv => $conv, rest => $rest);
}

# Convert sys.stdout.write()
sub cwrite {
   my ($line) = @_;
   
   my %ret = cline($line);
   my $toPrint = $ret{conv};
   my $rest = $ret{rest};

   # No end parameter
   my $conv = "print $toPrint";

   return (conv => $conv, rest => $rest);
}

# Convert range()
sub crange {
   my ($line) = @_;
   my @args = getArgs($line);
   my $rest = shift @args;

   my $start = 0;
   my $end;

   # If both start and end parameters given
   if ($#args > 0) {
      $start = shift @args;
   }

   # Python range() doesn't include the last number
   $end = "$args[0] - 1";

   my $conv = "($start..$end)";

   return (conv => $conv, rest => $rest);
}

# Get comma separated arguments into an array
sub getArgs {
   my ($line) = @_;
   my %ret = cline($line);
   my @args = ();

   %ret = cline($line);
   if ($ret{conv} ne '' || $ret{endType} eq 'comma') {
      push @args, $ret{conv};
   }

   while ($ret{endType} eq 'comma') {
      %ret = cline($ret{rest});
      push @args, $ret{conv};
   }

   # Return rest as first element in array (can be shifted off after calling getArgs())
   return ($ret{rest}, @args);
}






# Begin main
while (my $line = <>) {
   if ($line =~ /^#!/ && $. == 1) {
      print "#!/usr/bin/perl\n";

      # POSIX necessary for floor division
      print "use POSIX;\n";

      # Convert Perl ARGV into Python style where program name is first argument
      print "unshift(\@ARGV, \$0);\n";
      next;
   }

   # Remove trailing whitespace
   $line =~ s/\s+$/\n/; 

   # Print blank lines (preserves readability)
   if ($line =~ /^\s*$/) {
      print "\n";
      next;
   }

   # Store type of python indent when first found
   if (!$ind && $line =~ /^(\s+)\S/) {
      $ind = $1;
      $tabs = 1;
      #print "indent set to '$ind'\n";
   }

   # Close code blocks if they are finished
   while ($tabs > 0) {
      if (($line =~ /^\S/) || !($line =~ /^($ind){$tabs}/)) {
         my $totInd = "$spaces" x ($tabs-1);
         print "$totInd}\n";
         $tabs -= 1;
         #print "block ended\n";
      } else {
         last;
      }
   }
   
   # Convert Python line to Perl - loop will have to execute multiple times if semicolon separators are present
   my $rest = $line;
   while ($rest ne '') {

      # Begin each line with the appropriate indentation (x 3 spaces)
      my $perlLine = "$spaces" x $tabs;

      # Convert Python line to Perl
      my %convLine = cline($rest);
      $perlLine .= $convLine{conv};
      
      # Add a ';' at the end of commands
      if ($convLine{endType} eq 'command') {
         $perlLine .= ';';
      }

      $rest = $convLine{rest};

      print "$perlLine\n";
   }
}

# Close any unfinished blocks
while ($tabs > 0) {
   my $totInd = "$spaces" x ($tabs-1);
   print "$totInd}\n";
   $tabs -= 1;
}
