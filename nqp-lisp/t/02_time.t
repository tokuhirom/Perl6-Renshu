use strict;
use warnings;
use utf8;
use Test::More;
use t::Util;

like eval_lisp('(say (time))'), qr{\A\d+\.\d+\n?\z};

done_testing;

