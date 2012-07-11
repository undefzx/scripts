package restore;
use strict;
$|=1;
use Data::Dumper;

sub new{
	my $pkg = shift;
	my $obj = {
		'result' => '',
	};
	bless $obj, $pkg;
	return $obj;
}


require "parser_v0.1.pl";


#my $s = qq~<br><a href="/<bold>" style='<>' class="some 'strange' quotes" id="word">text</a> some bullshit < text  <br>~;

open FILE, "in.html";
my $s = join "", <FILE>;
close FILE;

my $parser = parser->new();                          


#print Dumper($parser->{'document'});

my $r = restore->new();

my $s1 = $r->do($parser->do($s));

open OUT, ">out.html";
print OUT $s1;
close OUT;

sub do{
	my $obj = shift;
	my $p = shift;

	open OUT, ">out.txt";
	print OUT Dumper($p->{'document'});
	close OUT;
	
	return $obj->print($p->{'document'});
}

sub print{
	my $obj = shift;
	my $tag = shift;

	my $text = '';

	if($tag->{'type'} eq 'tag'){
		if($tag->{'tag'} ne '.document'){
			$text .= '<'.$tag->{'tag'};
			foreach(@{$tag->{'param'}}){
				$text .= ' '.$_->{'name'}.'='.$_->{'quote'}.$_->{'value'}.$_->{'quote'};
			}
			$text .= $tag->{'is_closed'}? '>' : ' />';
		}
		foreach(@{$tag->{'child'}}){
			$text .= $obj->print($_);
		}

		if($tag->{'tag'} ne '.document'){
			$text .= '</'.$tag->{'tag'}.'>' if $tag->{'is_closed'};
		}
	}
	elsif($tag->{'type'} eq 'text'){
		$text .= $tag->{'content'};
	}

	return $text;
}