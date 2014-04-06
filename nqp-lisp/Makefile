all: test

test: lib/lisp.moarvm
	perl -Ilib test.pl

lib/lisp.moarvm: lisp.nqp
	nqp-m --target=mbc --output=lib/lisp.moarvm lisp.nqp

lib/lisp.pir: lisp.nqp
	nqp-p --target=pir --no-regex-lib --output=lib/lisp.pir lisp.nqp

clean:
	rm -f lib/lisp.moarvm lib/lisp.pir

.PHONY: clean all

