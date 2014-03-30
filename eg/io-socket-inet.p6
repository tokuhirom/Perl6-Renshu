use v6;

use lib 'lib';

my $sock = IO::Socket::INET.new(
    host => '64p.org',
    port => 80
);
$sock.send("GET / HTTP/1.0\n");
$sock.send("\n");
while (my $line = $sock.get()).defined {
    $line.say;
}
$sock.close;

=begin END

Perl6 の IO::Socket::INET をつかって､簡単な HTTP Client を書いてみた例｡

slurp メソッドが IO::Socket::INET から呼べないから､自前で実装してみている｡
まあ､通常は slurp 機能とか使わないので問題はない｡

