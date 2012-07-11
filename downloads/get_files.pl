use strict;
$| = 1;
use LWP::UserAgent;
my $ua = new LWP::UserAgent;
require HTTP::Headers;
my $h = new HTTP::Headers;
$ua->timeout(10);


for(my $i=1; $i < 2000; $i++){
	print "+" if get_img('land1/'.$i.'.gif');
}


sub get_img{
    my $file = shift;
	my $f = get_file_from('http://warchaos.ru/im/'.$file);
	return unless $f;
	open FILE,">$file";
	binmode FILE;
	print FILE $f;
	close FILE;
	return 1;
}


exit(0);


sub error_log{
	my $error = shift;
	open ERROR, ">>error.log" or die $!;
	print ERROR "$error";
	close ERROR;
}

sub get_location_from
{
  my $page = shift;
  my($req,$res);
  $ua->agent("Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)");
  $req = new HTTP::Request POST => $page,$h;
  $req->content('submit=Télécharger');
  $res = $ua->request($req);
  return $res->headers; # if ($res->is_success);
  return '';
}

sub get_file_from
{
  my $page = shift;
  my($req,$res);

  $ua->agent("Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)");
  $req = new HTTP::Request GET => $page;
  $res = $ua->request($req);
  return $res->content if ($res->is_success);
  return '';
}


sub get_head_from
{
  my $page = shift;
  my($req,$res);
  $ua->agent("Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)");
  $req = new HTTP::Request HEAD => $page;
  $res = $ua->request($req);
#  open RMB,'>res.htm'; if ($res->is_success) { print RMB $res->content } else { print RMB '' } close RMB;
  return $res->headers if ($res->is_success);
  return '';
}

