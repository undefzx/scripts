use strict;
use CSS::LESSp;

my $buffer;
open(IN, "file.less") or die $!;
while ( $_ = <IN> ) {
	$buffer .= $_;
}
close(IN);

my @css = CSS::LESSp->parse($buffer);


open OUT, ">s.css" or die $!;
print OUT join("", @css);
close OUT;
