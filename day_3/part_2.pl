#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

my $file_path = "input.txt";

my @lines;

open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";

while ( my $line = <$fh> ) {
    chomp $line;

    push @lines, $line;
}

close $fh;

my $enabled = 1;

my $sum = 0;

foreach my $input (@lines) {
    while ( $input =~ /(do\(\)|don't\(\)|mul\((\d+),(\d+)\))/g ) {
        my $match = $1;

        if ( $match eq 'do()' ) {
            $enabled = 1;
        }
        elsif ( $match eq "don't()" ) {
            $enabled = 0;
        }
        elsif ( $enabled && defined $2 && defined $3 ) {
            my ( $x, $y ) = ( $2, $3 );
            $sum += $x * $y;
        }
    }
}

say "Result: $sum";
