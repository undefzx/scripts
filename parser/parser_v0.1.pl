# скипание комментов вида <!-- -->
# тег script - парсит плохо если внутри есть теги в том или ином виде

package parser;
use strict;
$|=1;

sub new{
	my $pkg = shift;
	my $obj = {
		's' => [],
		'i' => -1,
		'max' => 0,
		'.document' => {},
		'state' => {
			'tag_opened' => 0,
			'quote_opened' => 0,
			'quote' => undef,
		},
		'opened_tags' => {},
		'active' => {},
		'tag_parsing' => 1,
		'mtag'		=> 'a-zA-Z',
		'mparam'	=> 'a-zA-Z\_0-9',
		'mspace'	=> '\s',
		'mquote'	=> '\"\'\`',
		'single_tags' => {
			'link'		=> 1,
			'input'		=> 1,
			'spacer'	=> 1,
			'img'		=> 1,
			'br'		=> 1,
			'hr'		=> 1,
		},
	};
	bless $obj, $pkg;

	$obj->{'document'} = $obj->tag();
	$obj->{'document'}->{'tag'} = '.document';
	$obj->{'document'}->{'is_closed'} = 1;
	$obj->{'active'} = $obj->{'document'};
	return $obj;
}

sub push{
	my $obj = shift;
	my $data = shift;
	my $tag = $data->{'tag'};
	$obj->{'opened_tags'}->{$tag} = [] unless $obj->{'opened_tags'}->{$tag};
	push @{$obj->{'opened_tags'}->{$tag}}, $data;
}

sub pop{
	my $obj = shift;
	my $data = shift;
	my $tag = $data->{'tag'};
	$obj->{'opened_tags'}->{$tag} = [] unless $obj->{'opened_tags'}->{$tag};
	return pop @{$obj->{'opened_tags'}->{$tag}};
}

sub do{
	my $obj = shift;
	my $s = shift;
	$obj->{'s'} = [split //,$s];
	$obj->{'i'} = 0;
	$obj->{'max'} = $#{$obj->{'s'}}+1;
	while(1){
		$obj->iteration();
#		$obj->{'i'}++;
		last if $obj->{'i'} >= $obj->{'max'};
	}
	return $obj;
}

sub iteration{
	my $obj = shift;
	my $s = $obj->{'s'};
	my $i = $obj->{'i'};
	my $max = $obj->{'max'};

	my $c0 = $i > 0 ? $s->[$i-1] : undef;
	my $c1 = $s->[$i];
	my $c2 = $i <= $max ? $s->[$i+1] : undef;
	my $c3 = $i+1 <= $max ? $s->[$i+2] : undef;

	# open tag
	if($c1 eq '<' && $c2 =~ m~[$obj->{'mtag'}]~ && !$obj->{'state'}->{'tag_opened'}){
#		print "1";
		$obj->{'i'}++;
		my $tag = $obj->tag();
		$tag->{'tag'} = $obj->get($obj->{'mtag'});
		$obj->{'state'}->{'tag_opened'} = 1;
		$tag->{'parent'} = $obj->{'active'};
		$obj->{'active'} = $tag;
		if (!$obj->{'single_tags'}->{$tag->{'tag'}}){
			$obj->push($tag);
		}
		push @{$tag->{'parent'}->{'child'}}, $tag;
	}
	# open /tag
	elsif($c1 eq '<' && $c2 eq '/' && $c3 =~ m~[$obj->{'mtag'}]~ && !$obj->{'state'}->{'tag_opened'}){
#		print "6";
		$obj->{'i'}++;
		$obj->{'i'}++;
		my $tag = $obj->tag();
		$tag->{'tag'} = $obj->get($obj->{'mtag'});
		$obj->{'state'}->{'tag_opened'} = 1;
#		$obj->{'active'} = $tag;
		my $t = $obj->pop($tag);
		$t->{'is_closed'}++;
		$obj->{'active'} = $t->{'parent'};
	}
	elsif($c1 eq '<' && $c2 !~ m~[$obj->{'mtag'}]~ && !$obj->{'state'}->{'tag_opened'}){
#		print "7";

#		$obj->{'active'} = $obj->text() unless $obj->{'active'}->{'type'} eq 'text';

		my $t = pop @{$obj->{'active'}->{'child'}};
		if($t->{'type'} ne 'text' && $t->{'type'}){
			push @{$obj->{'active'}->{'child'}}, $t;
			$t = $obj->text();
			$t->{'parent'} = $obj->{'active'};
		}
		elsif($t->{'type'} ne 'text'){
			$t = $obj->text();
			$t->{'parent'} = $obj->{'active'};
		}

		push @{$obj->{'active'}->{'child'}}, $t;

		$t->{'content'} .= '<';
		
		$obj->{'i'}++;
	}
	# close tag
	elsif($c1 eq '>' && $obj->{'state'}->{'tag_opened'}){
#		print "2";
#		print Dumper($obj->{'active'});
		$obj->{'state'}->{'tag_opened'} = 0;
		$obj->{'i'}++;
#		$obj->{'active'} = {};
        my $tag = $obj->{'active'};

		if ($obj->{'single_tags'}->{$tag->{'tag'}}){
			$obj->{'active'} = $tag->{'parent'};
		}

	}
	# tag param
	elsif($c1 =~ m~[$obj->{'mparam'}]~ && $obj->{'state'}->{'tag_opened'}){
#		print "3";
		push @{$obj->{'active'}->{'param'}}, $obj->get_param()
	}
	elsif($obj->{'state'}->{'tag_opened'}){
#		print "4";
#		print "=$obj->{'s'}->[$obj->{'i'}]=";
		$obj->get_not('>'.$obj->{'mparam'});
	}
	else{
		my $t = pop @{$obj->{'active'}->{'child'}};
		if($t->{'type'} ne 'text' && $t->{'type'}){
			push @{$obj->{'active'}->{'child'}}, $t;
			$t = $obj->text();
			$t->{'parent'} = $obj->{'active'};
		}
		elsif($t->{'type'} ne 'text'){
			$t = $obj->text();
			$t->{'parent'} = $obj->{'active'};
		}

		push @{$obj->{'active'}->{'child'}}, $t;

		$t->{'content'} .= $obj->get_not('<');
	
	}

	return $i;
}

sub get_param{
	my $obj = shift;
	my $r = $obj->param();
	$r->{'name'} = $obj->get($obj->{'mparam'});
	# пропускаем пробелы
	$obj->get($obj->{'mspace'});

	my $c1 = $obj->{'s'}->[$obj->{'i'}];

	if($c1 eq '='){
		$obj->{'i'}++;
		# пропускаем пробелы
		$obj->get($obj->{'mspace'});

		$c1 = $obj->{'s'}->[$obj->{'i'}];
		if($c1 =~ m~[$obj->{'mquote'}]~){
			$r->{'value'} = $obj->get_string($c1);
			$r->{'quote'} = $c1;
		}
		elsif($c1 eq '>'){
			return $r;
		}
		else{
			$r->{'value'} = $obj->get_string('');
			$r->{'quote'} = '"';
		}
	}
	return $r;
}

sub get_string{
	my $obj = shift;
	my $oq = shift;
	my $is_space = !$oq;
	my $r = '';
	$obj->{'i'}++ unless $is_space;
	$oq ||= '\s>';
	while($obj->{'s'}->[$obj->{'i'}] !~ m~[$oq]~ && length $obj->{'s'}->[$obj->{'i'}]){
		$r .= $obj->{'s'}->[$obj->{'i'}];
		$obj->{'i'}++;
	}
	$obj->{'i'}++ unless $is_space;
	return $r;
}

sub get{
	my $obj = shift;
	my $w = shift;
	my $r = '';

	while($obj->{'s'}->[$obj->{'i'}] =~ m~[$w]~){
		$r .= $obj->{'s'}->[$obj->{'i'}];
		$obj->{'i'}++;
	}
	return $r;
}

sub get_not{
	my $obj = shift;
	my $w = shift;
	my $r = '';

	while($obj->{'s'}->[$obj->{'i'}] !~ m~[$w]~ && length $obj->{'s'}->[$obj->{'i'}]){
		$r .= $obj->{'s'}->[$obj->{'i'}];
		$obj->{'i'}++;
	}
	return $r;
}

sub tag{
	return {'type'=>'tag', 'tag'=>undef, 'param' => [], 'child' => [], 'is_closed' => 0, 'parent' => undef};
}

sub text{
	return {'type'=>'text', 'content' => '', 'parent' => undef};
}

sub param{
	return {'type'=>'param', 'name' => '', 'value'=> '', 'quote' => ''};
}