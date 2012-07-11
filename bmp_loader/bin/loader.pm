package bin::loader;
use strict;

sub new{
	my $pkg = shift;
	my $obj = {
		# id, size, action, type
		'scheme' => [
			@_,
		],
		'data' => {},

	};
	bless $obj, $pkg;
	$obj->init();
	return $obj;
}

sub init{
	my $obj = shift;

}

sub load{
	my $obj = shift;
	my $file = shift;

	my $FILE = undef;
	open $FILE, "$file" or die $!;
	binmode $FILE;
	foreach my $d (@{$obj->{'scheme'}}){
		read $FILE, $obj->{'data'}->{$d->{'id'}}, $d->{'size'};
		if($d->{'action'} eq 'unpack'){
			$obj->{'data'}->{$d->{'id'}} = unpack($d->{'type'},$obj->{'data'}->{$d->{'id'}});
		}
		elsif($d->{'action'} eq 'eq'){
			die "$d->{'id'}: $obj->{'data'}->{$d->{'id'}} ne $d->{'type'}" if $obj->{'data'}->{$d->{'id'}} ne $d->{'type'};
		}
		elsif($d->{'action'} eq 'unpack_eq'){
			$obj->{'data'}->{$d->{'id'}} = unpack($d->{'type'}->[0],$obj->{'data'}->{$d->{'id'}});
			die "$d->{'id'}: $obj->{'data'}->{$d->{'id'}} ne $d->{'type'}->[1]" if $obj->{'data'}->{$d->{'id'}} ne $d->{'type'}->[1];
		}
		if($d->{'action'} eq 'function'){
			$obj->{'data'}->{$d->{'id'}} = $d->{'type'}->[0]($obj,$d, $FILE);
		}
	}
	close FILE;
}

sub save{
	my $obj = shift;
	my $file = shift;
	my $FILE = undef;
	open $FILE, ">$file" or die $!;
	binmode $FILE;
	foreach my $d (@{$obj->{'scheme'}}){
		if($d->{'action'} eq 'unpack'){
			print $FILE pack($d->{'type'},$obj->{'data'}->{$d->{'id'}});
		}
		elsif($d->{'action'} eq 'eq'){
			print $FILE $obj->{'data'}->{$d->{'id'}};
		}
		elsif($d->{'action'} eq 'unpack_eq'){
			print $FILE pack($d->{'type'}->[0],$obj->{'data'}->{$d->{'id'}});
		}
		if($d->{'action'} eq 'function'){
			$d->{'type'}->[1]($obj,$obj->{'data'}->{$d->{'id'}}, $FILE);
		}
	}
	close FILE;
}

sub get{
	my $obj = shift;
	my $key = shift;
	return $obj->{'data'}->{$key};
}

sub set{
	my $obj = shift;
	my $key = shift;
	my $value = shift;
	return $obj->{'data'}->{$key} = $value;
}

1;
