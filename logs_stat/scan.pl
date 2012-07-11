use strict;

my $dir = '.';

opendir DIR, $dir;
my @dirs = grep {-d $dir.'/'.$_ && m~^web~} readdir DIR;
closedir DIR;

my $IPS = {};
my $MAX = 
open LOG, ">log.txt" or die $!;
foreach(@dirs){
	scan_log("$dir/$_/domain-ag_access_log");
}
close LOG;

foreach(sort {$IPS->{$b} <=> $IPS->{$a}} keys %{$IPS}){
	print "$_\t$IPS->{$_}\n";
}


sub scan_log{
	my $file = shift;
	open FILE, $file or die $!;
	while($_=<FILE>){
		if (/redtram/igs){
		    m~^(\d+\.\d+\.\d+\.\d+)~;
			$IPS->{$1}++;
			s~^(\d+\.\d+\.\d+\.\d+ \d+\.\d+\.\d+\.\d+)~~igse;

			print LOG $_;
		}
	}
	close FILE;
}
