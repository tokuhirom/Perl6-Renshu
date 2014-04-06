use strict;
use warnings;
use utf8;
use Test::More;
use t::Util;

like eval_lisp('(say (time))'), qr{\A\d+\.\d+\n?\z};
is eval_lisp('(say (sha1 "HOGE"))'), "96E07BBD5540A76117AB213480AC2BE9F88A85CC\n";

done_testing;

