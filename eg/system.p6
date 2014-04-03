use v6;

# Perl5 の system() と同じことをしたい
{
    my $ret = shell('ls -l');
    $ret.exit.say;
}

# exit code がちゃんととれてることを確認
{
    my $ret = shell('exit 2');
    $ret.exit.say;
}

