# NQP について

## .moarvm に変換したい

MoarVM のバイトコードに変換したいときには以下のようにする｡

    ~/perl6/bin/moar --libpath=./src/vm/moar/stage0/  ./src/vm/moar/stage0/nqp.moarvm --bootstrap  --setting=NULL --no-regex-lib --target=mbc examples/fib.nqp

あるいは以下のようにしてもよい｡

    ./nqp-m --target=mbc --output=hello.moarvm examples/hello_world.nqp

