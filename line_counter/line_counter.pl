use strict;
use File::Find;
$| = 1;
my $time = time;

my $total_lines = 0;
my $total_files = 0;

find({ wanted => \&process, follow => 0 }, '.');

print "Files: $total_files\n";
print "Lines: $total_lines\n";

sub process{
	my $dir = $File::Find::dir;
	my $f = $_;
	my $path = $File::Find::name;
	return unless $f =~ m~\.(pl|pm|cgi)$~i;
	$total_lines += count_lines($f);
	$total_files++;
}

sub count_lines{
	my $path = shift;
	my $count = 0;
	open (FILE, "$path") || (print qq~Access error: "$path". $!\n~ and return 0);
	while($_ = <FILE>){
		next if $_ =~ m~^\s+$~;
		$count++;
	}
	close FILE;
	return $count;
}