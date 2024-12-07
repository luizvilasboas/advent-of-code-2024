#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

my $file_path = "input.txt";

my @grid;

open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";

while (my $line = <$fh>) {
    chomp;
    my @split = split(//, $line);
    push @grid, @split;
}

close $fh;

my $word     = "XMAS";
my $word_len = length($word);
my $count    = 0;

my $rows = scalar @grid;
my $cols = scalar @{ $grid[0] };

my @directions = (
    [  0,  1 ],    # Right
    [  1,  0 ],    # Down
    [  1,  1 ],    # Diagonal Down-Right
    [  1, -1 ],    # Diagonal Down-Left
    [  0, -1 ],    # Left
    [ -1,  0 ],    # Up
    [ -1, -1 ],    # Diagonal Up-Left
    [ -1,  1 ],    # Diagonal Up-Right
);

sub check_word {
    my ( $row, $col, $row_delta, $col_delta ) = @_;

    for my $i ( 0 .. $word_len - 1 ) {
        my $r = $row + $i * $row_delta;
        my $c = $col + $i * $col_delta;

        return 0 if $r < 0 || $r >= $rows || $c < 0 || $c >= $cols;

        return 0 if $grid[$r][$c] ne substr( $word, $i, 1 );
    }

    return 1;
}

for my $row ( 0 .. $rows - 1 ) {
    for my $col ( 0 .. $cols - 1 ) {
        for my $direction (@directions) {
            $count += check_word( $row, $col, @$direction );
        }
    }
}

say "Result: $count";
