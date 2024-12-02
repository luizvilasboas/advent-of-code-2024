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

my $count  = 0;
my $result = 0;

foreach my $value (@left_list) {
    $count = grep { $_ == $value } @right_list;
    $result += $value * $count;
}

say "Result: $result";
