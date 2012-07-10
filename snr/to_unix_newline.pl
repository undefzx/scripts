#!/usr/bin/env perl
use strict;

my $in = shift @ARGV;

die "File '$in' not found" unless -f $in;

my $out = '';
open IN, $in or die $!;
binmode IN;
while ($_ = <IN>) {
	s~\r$~~igs;
	$out .= $_;
}
close IN;

open OUT, ">$in" or die $!;
binmode OUT;
print OUT $out;
close OUT;
