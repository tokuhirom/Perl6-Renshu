use v6;

my $fd := nqp::socket(0);
nqp::connect($fd, "127.0.0.1", 80);
nqp::sayfh($fd, "GET / HTTP/1.0");
nqp::sayfh($fd, "");
nqp::say(nqp::readallfh($fd));
nqp::closefh($fd);

=begin END

NQP のメソッドを直接呼ぶこともできるみたい｡
あまりこれを直接よぶのはお行儀が良くないから､素人にはおすすめできない｡

ただ､なんか IO::Socket::INET が現行の Perl6 だとうまいこと使えないっぽくて､しょうがなくこれを試してみたのだった｡
