package t::Util;
use strict;
use warnings;
use utf8;
use 5.010_001;
use parent qw(Exporter);

use Capture::Tiny qw(capture);

our @EXPORT = qw(eval_lisp);

sub eval_lisp {
    my $code = shift;

    my ($stdout, $stderr, $exit) = capture {
        system('./bin/lisp', '-e', $code)
    };
    diag $stderr if $stderr;
    return $stdout;
}

1;

