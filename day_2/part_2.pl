#!/usr/bin/perl
use strict;
use warnings;

use feature 'say';

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
    my @levels   = @_;
    my $previous = -1;
    my $safe     = 1;

    for my $level (@levels) {
        if ( $previous == -1 ) {
            $previous = $level;
            next;
        }

        my $change = abs( $level - $previous );
        if ( $change > 3 ) {
            $safe = 0;
            last;
        }

        $previous = $level;
    }

    $safe = 0 unless is_growing(@levels) || is_descending(@levels);
    return $safe;
}

sub process_line {
    my @levels = @_;
    for my $index ( -1 .. $#levels ) {
        my @sublevels = @levels;
        splice @sublevels, $index, 1 if $index >= 0;

        return 1 if is_safe(@sublevels);
    }
    return 0;
}

my $file_path    = "input.txt";
my $safe_reports = 0;

open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";

while ( my $line = <$fh> ) {
    chomp $line;

    my @numbers = split ' ', $line;

    $safe_reports++ if process_line(@numbers);
}

close $fh;

say "Result: $safe_reports";
