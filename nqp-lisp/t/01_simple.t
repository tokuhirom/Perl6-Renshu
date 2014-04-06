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
        system('./bin/lisp', '-e', $code)
    };
    diag $stderr if $stderr;
    return $stdout;
}

__END__

===
--- input
(print (+))
--- expected
0

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

===
--- input
(print (-))
--- expected
0

===
--- input
(print (- 3))
--- expected
-3

===
--- input
(print (- 3 9))
--- expected
-6

===
--- input
(print (- 3 9 4))
--- expected
-10

===
--- input
(print (*))
--- expected
1

===
--- input
(print (* 2 4))
--- expected
8

===
--- input
(print (* 5 4 3))
--- expected
60

===
--- input
(print (/ 1024 2))
--- expected
512

===
--- input
(print (/ 1024 2 2))
--- expected
256

===
--- input
(print (* 3.14 2))
--- expected
6.28

===
--- input
(print (+ (* 3.14 2) 4))
--- expected
10.28

===
--- input
(print "hoge")
--- expected
hoge

===
--- SKIP
--- input
(print (~ "ho" "ge))
--- expected
hoge

===
--- input
(print "ho")
(print "ge")
--- expected
hoge

