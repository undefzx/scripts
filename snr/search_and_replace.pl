use strict;
use File::Copy;

my $backup_dir = '_bak';

mkdir($backup_dir);

scan_dir('.');

sub scan_dir{
	my $d = shift;
	opendir DIR, $d or return;
	my @f = grep {!m~^\.+$~} readdir DIR;
	closedir DIR;
	foreach(@f){
		next if $_ eq '_bak';
		my $file = "$d/$_";
		if(-f $file){
#			next unless m~\.(s?html?|aspx?|php)$~;
			scan_file($file);
		}
		elsif(-d $file){
			scan_dir($file);
		}
	}
}

sub scan_file{
	my $f = shift;
	open FILE, $f or return;
	while($_ = <FILE>){
		if(m~KEY_PHRASE~){
			print "$f\n";
			close FILE;
			scan_replace($f);
			return;
		}
	}
	close FILE;
}

sub scan_replace{
	my $f = shift;
	open FILE, $f or return;
	binmode FILE;
	my $s = join "", <FILE>;
	close FILE;
	if($s =~ s~\s*\QSEARCH_STRING\E~~){
		backup_file($f);
		open FILE, ">$f" or return;
		binmode FILE;
		print FILE $s;
		close FILE;
#		exit(0);
	}

}

sub backup_file{
	my $f = shift;
	my @d = split(/[\/\\]/, $f);
	my $i = 0;
	my $total = @d;
	my $d = $backup_dir;
	foreach(@d){
		$i++;
		next if $i == $total;
		$d .= '/'.$_;
		mkdir $d;
	}
	copy($f,$d);
}

1;
