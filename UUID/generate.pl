use Data::UUID;
use Digest::MD5;
my $ug = new Data::UUID;

#print unpack('H*',MD5($pass));


sub MD5{
	my $str = shift;
	my $md5 = Digest::MD5->new();
	$md5->add($str);
	return $md5->digest();
}



print pack('H*',uuid_get_hex());


sub uuid_get_hex{
	my $obj = shift;
	my $s = $ug->create();
	print $ug->to_hexstring( $s );
	print "\n  ";
	return unpack('H*',$s);
}

sub uuid_get_hex2{
	my $obj = shift;
	my $s = $ug->create_hex();
	return $s;
#	print $ug->to_hexstring( $s );
#	print "\n  ";
#	return unpack('H*',$s);
}