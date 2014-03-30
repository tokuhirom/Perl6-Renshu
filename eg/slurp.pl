use v6;

open('/etc/passwd').slurp().say;

=begin END

ファイルをオープンし､その中身をすべて読み取り､標準出力に出力させる｡
