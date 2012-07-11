package bmp_loader;
use strict;
use base 'bin::loader';

use Data::Dumper;

#my $l = bmp_loader->new();

#$l->load('Picture_left.bmp');

#$l->save('Picture_left_1.bmp');


sub init{
	my $obj = shift;
	$obj->{'scheme'} = [
		{ id => 'type', size => 2, action => 'eq', type=> 'BM'},
		{ id => 'size', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'reserved1', size => 2, action => 'unpack', type=> 'S'},
		{ id => 'reserved2', size => 2, action => 'unpack', type=> 'S'},
		{ id => 'offset_bits', size => 4, action => 'unpack', type=> 'L'},
		# Информационный заголовок (BitMapInfoHeader)
		{ id => 'bmih_size', size => 4, action => 'unpack_eq', type=> ['L','40']},
		{ id => 'width', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'height', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'planes', size => 2, action => 'unpack', type=> 'S'},
		{ id => 'bit_count', size => 2, action => 'unpack', type=> 'S'},
		{ id => 'compression', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'size_image', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'x_pels_per_meter', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'y_pels_per_meter', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'colors_used', size => 4, action => 'unpack', type=> 'L'},
		{ id => 'colors_important', size => 4, action => 'unpack', type=> 'L'},
		# image data
		{ id => 'data', size => 0, action => 'function', type=> [\&load_data, \&save_data]},
	];
}

sub load_data{
	my $obj = shift;
	my $d = shift;
	my $FILE = shift;
	my $data = [];
	for(my $y=0; $y< $obj->get('height'); $y++){
		for(my $x=0; $x< $obj->get('width'); $x++){
			my $r = 0;
			my $g = 0;
			my $b = 0;
			read $FILE, $r, 1;
			read $FILE, $g, 1;
			read $FILE, $b, 1;
#			$r = unpack('C',$r);
#			$g = unpack('C',$g);
#			$b = unpack('C',$b);
			$r = ord($r);
			$g = ord($g);
			$b = ord($b);

			$data->[$x]->[$y] = [$r,$g,$b];
		}
	}
	return $data;
}

sub save_data{
	my $obj = shift;
	my $data = shift;
	my $FILE = shift;
	for(my $y=0; $y< $obj->get('height'); $y++){
		for(my $x=0; $x< $obj->get('width'); $x++){
			print $FILE pack('C',$data->[$x]->[$y]->[0]);
			print $FILE pack('C',$data->[$x]->[$y]->[1]);
			print $FILE pack('C',$data->[$x]->[$y]->[2]);
		}
	}
}

sub get_pixel{
	my $obj = shift;
	my $x = shift;
	my $y = shift;
	return reverse @{$obj->get('data')->[$x]->[$y]};
}

sub set_pixel{
	my $obj = shift;
	my $x = shift;
	my $y = shift;
	$obj->get('data')->[$x]->[$y] = [reverse @_];
}


1;
