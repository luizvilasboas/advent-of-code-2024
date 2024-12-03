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

my @values;

my $sum = 0;

foreach my $input (@lines) {
    while ( $input =~ /mul\((\d+),(\d+)\)/g ) {
        my ( $x, $y ) = ( $1, $2 );
        $sum += $x * $y;
    }
}

say "Result: $sum";
