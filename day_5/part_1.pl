#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

sub read_file {
    my ($file_path) = @_;

    open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";

    my ( @rules, @updates );

    my $is_rule_section = 1;
    while ( my $line = <$fh> ) {
        chomp $line;

        if ( $line =~ /,/ ) {
            push @updates, [ split /,/, $line ];
        }

        else {
            if ($is_rule_section) {
                my @rule = split /\|/, $line;

                if ( @rule == 2 ) {
                    push @rules, \@rule;
                }
            }
        }
    }

    close $fh;
    return ( \@rules, \@updates );
}

sub is_valid_update {
    my ( $update, $rules ) = @_;
    my %hash_map = map { $_ => 1 } @$update;

    for my $rule (@$rules) {
        my ( $before, $after ) = @$rule;

        next if !exists $hash_map{$before} || !exists $hash_map{$after};

        my $before_index = 0;
        my $after_index  = 0;
        for my $i ( 0 .. $#$update ) {
            if ( $update->[$i] == $before ) {
                $before_index = $i;
            }
            if ( $update->[$i] == $after ) {
                $after_index = $i;
            }
        }

        if ( $before_index > $after_index ) {
            return 0;
        }
    }

    return 1;
}

sub calculate_middle_page {
    my ($update) = @_;
    my $middle_index = int( @$update / 2 );
    return $update->[$middle_index];
}

my $filename = 'input.txt';

my ( $rules, $updates ) = read_file($filename);

my $sum_middle_pages = 0;
my @valid_updates;

for my $update (@$updates) {
    if ( is_valid_update( $update, $rules ) ) {
        push @valid_updates, $update;
        my $middle_page = calculate_middle_page($update);
        $sum_middle_pages += $middle_page;
    }
}

say "Result: $sum_middle_pages";
