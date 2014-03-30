use v6;

my $sock = IO::Socket::INET.new(
    listen    => True,
    localhost => '127.0.0.1',
    localport => 9989,
);
while my $csock = $sock.accept {
    my $buf = buf8.new;
    loop {
        my $current = $csock.recv(:bin);
        last if $current.bytes == 0;
        $buf ~= $current;

        if $buf.decode('ascii') ~~ /
            ^^
            [
                $<method>=( <[A .. Z]>+ )
                \s+
                $<path>=( <[A .. Z / ]>+ )
                \s+
                'HTTP/1.' <[0 .. 9]>
                \n
            ]
            [ (\N+) \n ]*?
            \n
        / {
            say "METHOD: { $/<method> }";
            say "PATH: { $/<path> }";
            $/[0].say;

            my $content = "Yatta!\n";
            $csock.write(
                [
                    "HTTP/1.0 200 OK",
                    "Content-Type: text/plain",
                    "Content-Length: {$content.chars}",
                    "",
                    $content,
                ].join("\n").encode('utf-8')
            );
            say "HAH";
            last;
        }
    }
    $csock.close;
}


=begin END

簡単な http server の例｡


