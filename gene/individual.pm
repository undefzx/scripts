package individual;
use strict;

sub new{
	my $pkg = shift;
	my $obj = {
		'gene' => [0,0,0,0],
	};
	bless $obj, $pkg;
	return $obj;
}

sub adam{
	my $obj = shift;
	$obj->{'gene'}->[0] = int(rand(30))+1;
	$obj->{'gene'}->[1] = int(rand(30))+1;
	$obj->{'gene'}->[2] = int(rand(30))+1;
	$obj->{'gene'}->[3] = int(rand(30))+1;
	return $obj;
}

sub cross_over{
	my $obj = shift;
	my $i2 = shift;
	my $i1 = $obj;
	my $i3 = individual->new();
	my $g = int(rand(3));
	my $s = int(rand(2));

	if($s == 0){
		my $k = 0;
		foreach(@{$i1->{'gene'}}){
			$i3->{'gene'}->[$k] = $_;
			$k++;
		}

		$i3->{'gene'}->[$g]		= $i1->{'gene'}->[$g];
		$i3->{'gene'}->[$g+1]	= $i2->{'gene'}->[$g+1];
	}
	else{
		my $k = 0;
		foreach(@{$i2->{'gene'}}){
			$i3->{'gene'}->[$k] = $_;
			$k++;
		}

		$i3->{'gene'}->[$g]		= $i2->{'gene'}->[$g];
		$i3->{'gene'}->[$g+1]	= $i1->{'gene'}->[$g+1];
	}

	return $i3;
}

sub mutate{
	my $obj = shift;
	my $g = int(rand(4));
	$obj->{'gene'}->[$g] += int(rand(8))-4;
	$obj->{'gene'}->[$g] = 1 if $obj->{'gene'}->[$g] <= 0;
	$obj->{'gene'}->[$g] = 30 if $obj->{'gene'}->[$g] > 30;
}

sub print{
	my $obj = shift;
	return "[$obj->{'gene'}->[0],$obj->{'gene'}->[1],$obj->{'gene'}->[2],$obj->{'gene'}->[3]]";
}

1;
