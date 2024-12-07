#!/usr/bin/perl
use strict;
use warnings;

use feature "say";

my $file_path = "input.txt";
my $sum       = 0;

my @rules = read_rules($file_path);

process_updates($file_path);

say "Result: $sum";

sub read_rules {
    my ($file) = @_;
    my @rules;

    open my $inFH, '<', $file or die "Cannot open file '$file': $!";
    while ( my $line = <$inFH> ) {
        chomp($line);
        push @rules, $line if $line =~ /\|/;
    }
    close $inFH;

    return @rules;
}

sub process_updates {
    my ($file_path) = @_;

    open my $fh, '<', $file_path or die "Could not open file '$file_path': $!";
    while ( my $line = <$fh> ) {
        chomp($line);

        if ( $line !~ /^\s*$/ ) {
            my $res = eval_update($line);
            if ( $res == 0 ) {
                $sum += correct_update($line);
            }
        }
    }
    close $fh;
}

sub correct_update {
    my ($line)   = @_;
    my @split    = split( /,/, $line );
    my %rule_map = map { $_ => 1 } @rules;

    while (1) {
        my $cnt = 0;
        for my $i ( 0 .. $#split ) {
            for my $j ( $i + 1 .. $#split ) {
                if ( $rule_map{"$split[$j]|$split[$i]"} ) {
                    @split[ $i, $j ] = @split[ $j, $i ];
                    $cnt++;
                }
            }
        }
        last if $cnt == 0;
    }

    return $split[ int( $#split / 2 ) ];
}

sub eval_update {
    my ($line)   = @_;
    my @split    = split( /,/, $line );
    my %rule_map = map { $_ => 1 } @rules;

    for my $i ( 0 .. $#split ) {
        for my $j ( $i + 1 .. $#split ) {
            return 0 unless $rule_map{"$split[$i]|$split[$j]"};
        }
        for my $j ( 0 .. $i - 1 ) {
            return 0 unless $rule_map{"$split[$j]|$split[$i]"};
        }
    }

    return $split[ int( $#split / 2 ) ];
}
