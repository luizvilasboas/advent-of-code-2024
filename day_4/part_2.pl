#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

use constant {
    FILE_PATH => "input.txt",
    SEARCH_PATTERN => [ 'X', 'M', 'A', 'S' ],
};

my %map;
my ( $max_y, $max_x ) = ( -1, 0 );

sub main {
    load_map(FILE_PATH);
    my $count = count_xMAS();
    say "Result: $count";
}

sub load_map {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Não foi possível abrir o arquivo '$file_path': $!";

    while ( my $line = <$fh> ) {
        chomp $line;
        my @split = split //, $line;

        $max_x = $#split if $#split > $max_x;
        $max_y++;
        $map{$max_y}{$_} = $split[$_] for 0 .. $#split;
    }

    close $fh;
}

sub count_xMAS {
    my $count = 0;
    for my $y ( 0 .. $max_y ) {
        for my $x ( 0 .. $max_x ) {
            $count += search_xMAS( $y, $x ) if $map{$y}{$x} eq SEARCH_PATTERN->[2];
        }
    }
    return $count;
}

sub search_xMAS {
    my ( $y, $x ) = @_;
    my $count = 0;

    my @directions = (
        { M1 => [-1, -1], M2 => [ 1, -1], S1 => [-1,  1], S2 => [ 1,  1] },
        { M1 => [-1, -1], M2 => [-1,  1], S1 => [ 1, -1], S2 => [ 1,  1] },
        { M1 => [-1,  1], M2 => [ 1,  1], S1 => [-1, -1], S2 => [ 1, -1] },
        { M1 => [ 1,  1], M2 => [ 1, -1], S1 => [-1, -1], S2 => [-1,  1] },
    );

    for my $dir (@directions) {
        if (
            check_position( $y + $dir->{M1}[0], $x + $dir->{M1}[1], 'M' ) &&
            check_position( $y + $dir->{M2}[0], $x + $dir->{M2}[1], 'M' ) &&
            check_position( $y + $dir->{S1}[0], $x + $dir->{S1}[1], 'S' ) &&
            check_position( $y + $dir->{S2}[0], $x + $dir->{S2}[1], 'S' )
        ) {
            $count++;
        }
    }

    return $count;
}

sub check_position {
    my ( $y, $x, $char ) = @_;
    return $map{$y}{$x} && $map{$y}{$x} eq $char;
}

main();
