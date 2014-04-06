all: lib/lisp.moarvm

test: lib/lisp.moarvm
	prove -vr t/

lib/lisp.moarvm: lisp.nqp
	nqp-m --target=mbc --output=lib/lisp.moarvm lisp.nqp

clean:
	rm -f lib/lisp.moarvm

.PHONY: clean all

