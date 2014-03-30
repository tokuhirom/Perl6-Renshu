use v6;

say '-- 単にマッチさせる';
{
    my $buf = 'aaa';
    $buf ~~ /(a*)/ or die;
    say $/[0];
}

say '-- Named Capture';
{
    my $buf = '私の名前は中野です';
    $buf ~~ /名前は$<name>=(.*)です/ or die;
    say $/<name>;
}
