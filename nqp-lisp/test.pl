#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010000;
use autodie;
use Capture::Tiny qw(capture);
use Test::Base::Less;

filters {
    input    => ['chomp'],
    expected => ['chomp'],
};

for (blocks) {
    my $expected = $_->expected;
    $expected =~ s/\n\z//;
    is(eval_lisp($_->input), $expected, $_->input);
}

done_testing;
exit 0;

sub eval_lisp {
    my $code = shift;

    my ($stdout, $stderr, $exit) = capture {
        system('nqp-m', 'lisp.nqp', '-e', $code)
    };
    diag $stderr if $stderr;
    return $stdout;
}

__END__

===
--- input
(print (+ 5 4))
--- expected
9

===
--- input
(print (+ 5 4 3))
--- expected
12

