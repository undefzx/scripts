package test::net::server;
use strict;

use base qw(Net::Server); # any personality will do

test::net::server->run(port => 160);

### over-ridden subs below

sub process_request {
    my $self = shift;
    eval {

        local $SIG{'ALRM'} = sub { die "Timed Out!\n" };
        my $timeout = 30; # give the user 30 seconds to type some lines

        my $previous_alarm = alarm($timeout);
        while (<STDIN>) {
            s/\r?\n$//;
            print "You said '$_'\r\n";
			last if m~^last$~i;
			exit if m~^(quit|exit)$~i;
            alarm($timeout);
        }
        alarm($previous_alarm);

    };

    if ($@ =~ /timed out/i) {
        print STDOUT "Timed Out.\r\n";
        return;
    }

}

1;

1;
