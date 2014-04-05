#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010000;
use autodie;
use Capture::Tiny qw(capture);
use Test::More;

is(run('(print (+ 5 4))'), 9);
is(run('(print (+ 5 4 3))'), 12);

done_testing;
exit 0;

sub run {
    my $code = shift;

    my ($stdout, $stderr, $exit) = capture {
        system('nqp-m', 'lisp.nqp', '-e', $code)
    };
    diag $stderr if $stderr;
    return $stdout;
}
