nqp-list
========

NQP を使って作られた lisp 処理系､のプロトタイプです｡
基本､scheme っぽい感じを目指してるけど､そこまでいかない可能性も多々あります｡

## 困ってること

nqp-m 使った時に､`nqp-m lisp.nqp -e 0` みたいにすると以下の様なエラーになる｡おっかしいな｡

    Too many positional parameters passed; got 1 but expected 0
      at -e:1  (<ephemeral file>::0)
    from gen/moar/stage2/NQPHLL.nqp:1091  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:eval:174)
    from gen/moar/stage2/NQPHLL.nqp:1180  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm::35)
    from gen/moar/stage2/NQPHLL.nqp:1177  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:command_eval:154)
    from gen/moar/stage2/NQPHLL.nqp:1162  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:command_line:109)
    from lisp.nqp:100  (<ephemeral file>:MAIN:40)
    from lisp.nqp:92  (<ephemeral file>::44)
    from gen/moar/stage2/NQPHLL.nqp:1091  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:eval:174)
    from gen/moar/stage2/NQPHLL.nqp:1283  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:evalfiles:86)
    from gen/moar/stage2/NQPHLL.nqp:1187  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:command_eval:212)
    from gen/moar/stage2/NQPHLL.nqp:1162  (/home/tokuhirom/perl6/languages/nqp/lib/NQPHLL.moarvm:command_line:109)
    from gen/moar/stage2/NQP.nqp:3932  (/home/tokuhirom/perl6/languages/nqp/lib/nqp.moarvm:MAIN:16)
    from gen/moar/stage2/NQP.nqp:3927  (/home/tokuhirom/perl6/languages/nqp/lib/nqp.moarvm::335)
    from <unknown>:1  (/home/tokuhirom/perl6/languages/nqp/lib/nqp.moarvm::8)
    from <unknown>:1  (/home/tokuhirom/perl6/languages/nqp/lib/nqp.moarvm::9)

src/HLL/Compiler.nqp の eval() があやしいね｡

