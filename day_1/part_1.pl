#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

my $file_path = "input.txt";

my @left_list;
my @right_list;

open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";

while ( my $line = <$fh> ) {
    chomp $line;

    my ( $left, $right ) = split( /\s+/, $line );

    push @left_list,  $left;
    push @right_list, $right;
}

close $fh;

@left_list  = sort { $a <=> $b } @left_list;
@right_list = sort { $a <=> $b } @right_list;

my $difference = 0;

for my $i ( 0 .. $#left_list ) {
    $difference += abs $right_list[$i] - $left_list[$i];
}

say "Result: $difference";
