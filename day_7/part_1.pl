#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

my $file = "input.txt";
open my $fh, '<', $file or die "Cannot open $file: $!";

my @input = <$fh>;
close $fh;
chomp @input;

sub evaluate {
    my ( $nums, $target, $index, $current_value ) = @_;

    if ( $index == @$nums ) {
        return $current_value == $target;
    }

    my $next_num = $nums->[$index];
    return evaluate( $nums, $target, $index + 1, $current_value + $next_num )
      || evaluate( $nums, $target, $index + 1, $current_value * $next_num );
}

my $total_calibration_result = 0;
foreach my $line (@input) {
    my ( $target, $numbers_str ) = split /: /, $line;
    my @numbers = split / /, $numbers_str;

    if ( evaluate( \@numbers, $target, 1, $numbers[0] ) ) {
        $total_calibration_result += $target;
    }
}

say "Result: $total_calibration_result";
