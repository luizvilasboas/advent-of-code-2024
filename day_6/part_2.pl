#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

my $path = "input.txt";

open( my $fh, '<', $path ) or die "Cannot open file: $!";
my @file = <$fh>;
chomp @file;
close($fh);

my @field;
my @directions = ( [ 0, -1 ], [ 1, 0 ], [ 0, 1 ], [ -1, 0 ] );
my ( $pos_x, $pos_y ) = ( -1, -1 );

foreach my $line (@file) {
    push @field, [ split //, $line ];
    next if $pos_x != -1;
    my $gStart = index( $line, "^" );
    if ( $gStart != -1 ) {
        $pos_x = $gStart;
        $pos_y = scalar(@field) - 1;
    }
}

sub printField {
    my ( $positions, $mark, $obstacle ) = @_;
    $mark     //= 'X';
    $obstacle //= [ -1, -1 ];

    return if scalar(@field) > 20;

    foreach my $y ( 0 .. $#field ) {
        my $line = "";
        foreach my $x ( 0 .. $#{ $field[$y] } ) {
            if ( grep { $_->[0] == $x && $_->[1] == $y } @$positions ) {
                $line .= $mark;
            }
            elsif ( $x == $obstacle->[0] && $y == $obstacle->[1] ) {
                $line .= "0";
            }
            else {
                $line .= $field[$y][$x];
            }
        }
        print "$line\n";
    }
    print "\n";
}

sub turnRight {
    my ($dir) = @_;
    $dir++;
    $dir = 0 if $dir == 4;
    return $dir;
}

sub posIsObstacle {
    my ($pos) = @_;
    return $field[ $pos->[1] ][ $pos->[0] ] eq "#";
}

sub posIsStart {
    my ($pos) = @_;
    return $field[ $pos->[1] ][ $pos->[0] ] eq "^";
}

sub checkOutOfBounds {
    my ($pos) = @_;
    return
         $pos->[0] < 0
      || $pos->[0] >= scalar( @{ $field[0] } )
      || $pos->[1] < 0
      || $pos->[1] >= scalar(@field);
}

sub getNext {
    my ( $pos, $dir ) = @_;
    return [ $pos->[0] + $directions[$dir][0],
        $pos->[1] + $directions[$dir][1] ];
}

sub checkForLoop {
    my ( $pos, $dir, $obstaclePos ) = @_;
    my %trace;

    while (1) {
        my $nextPos = getNext( $pos, $dir );
        return 0 if checkOutOfBounds($nextPos);

        if (
            posIsObstacle($nextPos)
            || (   $nextPos->[0] == $obstaclePos->[0]
                && $nextPos->[1] == $obstaclePos->[1] )
          )
        {
            $dir = turnRight($dir);
            next;
        }

        if ( exists $trace{"$nextPos->[0],$nextPos->[1]"} && grep { $_ == $dir }
            @{ $trace{"$nextPos->[0],$nextPos->[1]"} } )
        {
            return \%trace;
        }

        $pos = $nextPos;
        push @{ $trace{"$pos->[0],$pos->[1]"} }, $dir;
    }
}

my $mainDir = 0;
my %result;
my %visited;
my $pos = [ $pos_x, $pos_y ];

while (1) {
    my $nextPos = getNext( $pos, $mainDir );
    last if checkOutOfBounds($nextPos);

    if ( posIsObstacle($nextPos) ) {
        $mainDir = turnRight($mainDir);
        next;
    }

    my $obstacle = $nextPos;
    if (   !exists $result{"$obstacle->[0],$obstacle->[1]"}
        && !posIsStart($obstacle)
        && !exists $visited{"$obstacle->[0],$obstacle->[1]"} )
    {
        my $foundLoop = checkForLoop( $pos, turnRight($mainDir), $obstacle );
        if ($foundLoop) {
            $result{"$obstacle->[0],$obstacle->[1]"} = 1;
        }
    }

    $pos = $nextPos;
    $visited{"$pos->[0],$pos->[1]"} = 1;
}

say "Result: ", scalar( keys %result );
