use File::Basename;
use Fcntl qw(LOCK_EX LOCK_NB);
use strict;

my $ProgramName = basename($0);

open(SELFLOCK, "<$0") or die("Couldn't open $0: $!\n");
flock(SELFLOCK, LOCK_EX | LOCK_NB) or die("Aborting: another $ProgramName is already running\n");

# Do any necessary preliminary checks (e.g. check a config file)

# Get ready to daemonize by redirecting our output to syslog, requesting that logger prefix the lines with our program name:
open(STDOUT, "|-", "logger -t $ProgramName") or die("Couldn't open logger output stream: $!\n");
open(STDERR, ">&STDOUT") or die("Couldn't redirect STDERR to STDOUT: $!\n");
$| = 1; # Make output line-buffered so it will be flushed to syslog faster

chdir('/'); # Avoid the possibility of our working directory resulting in keeping an otherwise unused filesystem in use

# Double-fork to avoid leaving a zombie process behind:
exit if (fork());
exit if (fork());
sleep 1 until getppid() == 1;

print "$ProgramName $$ successfully daemonized\n";

# do something useful