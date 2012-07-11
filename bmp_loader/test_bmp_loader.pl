use strict;
use bmp_loader;
use List::Util qw[min max];
use POSIX qw(ceil floor);
use Data::Dumper;
$| = 1;
my $ri = load_img('Picture_right.bmp');

#$ri->{'data'}->{'data'}='';
#print Dumper($ri);
#exit(0);

for(my $y=0; $y < $ri->get('height'); $y++){

	$ri->set_pixel(120,$y,255,255,255);
}


$ri->save('ri.bmp');

sub load_img{
	my $file = shift;
	my $img = bmp_loader->new();
	$img->load($file);
	return $img;
}
