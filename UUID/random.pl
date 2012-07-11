use Data::UUID;
use Digest::MD5;
my $ug = new Data::UUID;

#print unpack('H*',MD5($pass));


sub md5{
	my $str = shift;
	my $md5 = Digest::MD5->new();
	$md5->add($str);
	return $md5->hexdigest();
}



print rand_md5();


sub rand_md5{
	my $obj = shift;
	my $s = $ug->create();
	return md5($s.rand().rand().rand().$$.time().rand().rand());
}

sub uuid_get_hex2{
	my $obj = shift;
	my $s = $ug->create_hex();
	return $s;
#	print $ug->to_hexstring( $s );
#	print "\n  ";
#	return unpack('H*',$s);
}