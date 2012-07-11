package world;
use strict;
use individual;

sub new{
	my $pkg = shift;
	my $obj = {
		'population_num'	=> 0,
		'population_count'	=> 100,
		'population'		=> [],
	};
	bless $obj, $pkg;
	return $obj;
}

sub big_bang{
	my $obj = shift;
	$obj->{'population'} = [];
	$obj->{'population_num'}++;
	for(my $i=0; $i < $obj->{'population_count'}; $i++){
		push(@{$obj->{'population'}},individual->new->adam);
	}

}

sub show_stat{
	my $obj = shift;
	my $cnt = 0;
	print "Population: $obj->{'population_num'}\n";
	foreach my $i (@{$obj->{'population'}}){
		$cnt++;
		print "$cnt: ".$obj->fitness($i)."\t".$i->print."\n";
	}
}

sub choose{
	my $obj = shift;
	my $sum = 0;
	my @num = ();

	foreach(@{$obj->{'population'}}){
		my $fitness = $obj->fitness($_);
		$sum += ($fitness ? 1/$fitness : 2);
	}
	my $sum_p = 0;
	foreach(@{$obj->{'population'}}){
		my $fitness = $obj->fitness($_);
		$sum_p += ($fitness ? 1/$fitness : 2)/$sum;
		push(@num, $sum_p);
	}
	my $num = rand($sum_p);
	my $i = 0;
	foreach(@num){
		if($num <= $_){
			return $obj->{'population'}->[$i];
		}
		$i++;
	}

	return $obj->{'population'}->[$i];
}

sub populate{
	my $obj = shift;

	my @next_gen = ();
	for(my $i=0; $i < $obj->{'population_count'}; $i++){
		my $i1 = $obj->choose;
		my $i2 = $obj->choose;
		push @next_gen, $i1->cross_over($i2);
	}
	@{$obj->{'population'}} = @next_gen;
	foreach(@{$obj->{'population'}}){
		$_->mutate;
	}
	@{$obj->{'population'}}	= sort {$obj->fitness($a) <=> $obj->fitness($b)} @{$obj->{'population'}};
	$obj->{'population_num'}++;
}

sub cross_over{
	my $obj = shift;
	my $i1 = shift;
	my $i2 = shift;

}

sub fitness{
	my $obj = shift;
	my $i = shift;
	return abs($i->{'gene'}->[0]+2*$i->{'gene'}->[1]+3*$i->{'gene'}->[2]+4*$i->{'gene'}->[3]-30);
}

sub run{
	my $obj = shift;
	my $i = 100;
MAIN:
	while($i--){
		$obj->populate;
		foreach(@{$obj->{'population'}}){
			if(!$obj->fitness($_)){
#				print "Found!\n";
#				last MAIN;
			}
		}
	}
	$obj->show_stat;
}

1;
