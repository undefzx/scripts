#!/usr/bin/perl

use strict;
use warnings;

use Proc::Daemon;
use Proc::PID::File;

MAIN:
{
    # Daemonize
    Proc::Daemon::Init();

    # If already running, then exit
    if (Proc::PID::File->running()) {
        exit(0);
    }

    # Perform initializes here

    # Enter loop to do work
    for (;;) {
        # Do whatcha gotta do
    }
}