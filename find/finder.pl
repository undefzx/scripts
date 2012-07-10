use strict;
use File::Find;
$| = 1;
my $time = time;
find({ wanted => \&process, follow => 0 }, './');

sub process{
	my $dir = $File::Find::dir;
	my $f = $_;
	my $path = $File::Find::name;
	my $mtime = (stat($path))[9];
	if($mtime > $time - 31*24*3600){
		print "$path\n";
	}
}
