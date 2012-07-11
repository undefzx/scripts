package lib::uuid;
use strict;
use Data::UUID;

sub new{
	my $pkg = shift;
	my $obj = {
		'_uuid' => undef,
	};
	bless $obj, $pkg;
	$obj->{'_uuid'} = new Data::UUID;
	return $obj;
}

sub create{
	my $obj = shift;
	return $obj->{'_uuid'}->create(@_);
}

sub create_hex{
	my $obj = shift;
	return $obj->to_hex($obj->{'_uuid'}->create(@_));
}

sub to_hex{
	my $obj = shift;
	my $s = shift;
	return unpack('H*',$s);
}

sub from_hex{
	my $obj = shift;
	my $s = shift;
	return pack('H*',$s);
}

1;
