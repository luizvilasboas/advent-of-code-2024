#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

sub simulate_guard_patrol {
    my ($map_input)     = @_;
    my @directions      = ( [ -1, 0 ], [ 0, 1 ], [ 1, 0 ], [ 0, -1 ] );
    my @direction_chars = ( '^', '>', 'v', '<' );
    my %visited_positions;

    my @grid = map { [ split // ] } @$map_input;

    my $guard_position;
    for my $r ( 0 .. $#grid ) {
        for my $c ( 0 .. $#{ $grid[$r] } ) {
            if ( $grid[$r][$c] eq '^' ) {
                $guard_position = [ $r, $c ];
                $grid[$r][$c] = '.';
                last;
            }
        }
    }

    my $direction = 0;
    my ( $r, $c ) = @$guard_position;
    $visited_positions{"$r,$c"} = 1;

    while (1) {
        my ( $dr, $dc ) = @{ $directions[$direction] };
        my ( $nr, $nc ) = ( $r + $dr, $c + $dc );

        if ( $nr < 0 || $nr >= @grid || $nc < 0 || $nc >= @{ $grid[$nr] } ) {
            last;
        }

        if ( $grid[$nr][$nc] eq '#' ) {
            $direction = ( $direction + 1 ) % 4;
        }
        else {
            ( $r, $c ) = ( $nr, $nc );
            $visited_positions{"$r,$c"} = 1;
        }
    }

    return scalar( keys %visited_positions );
}

sub read_map_from_file {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";
    my @map_input = <$fh>;
    chomp @map_input;
    close $fh;
    return \@map_input;
}

my $file_path = "input.txt";
my $map_input = read_map_from_file($file_path);
my $result    = simulate_guard_patrol($map_input);

say "Result: $result";
