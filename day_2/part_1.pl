#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

sub is_growing {
    my @numbers = @_;

    return 0 if @numbers <= 1;

    for my $i ( 1 .. $#numbers ) {
        return 0 if $numbers[$i] <= $numbers[ $i - 1 ];
    }

    return 1;
}

sub is_descending {
    my @numbers = @_;

    return 0 if @numbers <= 1;

    for my $i ( 1 .. $#numbers ) {
        return 0 if $numbers[$i] >= $numbers[ $i - 1 ];
    }

    return 1;
}

sub is_safe {
    my ( $numbers_ref, $growing, $descending ) = @_;
    my @numbers = @$numbers_ref;

    for my $i ( 1 .. $#numbers ) {
        my $differ = abs( $numbers[$i] - $numbers[ $i - 1 ] );

        return 0 if $differ > 3 || $differ < 1;
    }

    return 1;
}

my $file_path    = "input.txt";
my $safe_reports = 0;

open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";

while ( my $line = <$fh> ) {
    chomp $line;

    my @numbers = split ' ', $line;

    my $is_growing    = is_growing(@numbers);
    my $is_descending = is_descending(@numbers);

    if ( $is_growing || $is_descending ) {
        my $safe = is_safe( \@numbers, $is_growing, $is_descending );
        $safe_reports++ if $safe;
    }
}

close $fh;

say "Result: $safe_reports";
