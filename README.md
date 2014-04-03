# Perl6-Renshu

## What's this repository?

This is my excersise code for Perl6.

これは､Perl6の練習のための習作です｡

なんか勘違いしているところがあったりするかもしれないけど､問題あったら p-r か issues でお知らせください｡

あるいは､なにか古くなったりするかもしれませんので､そういう場合にもお伝え願えればと思います｡

## Perl6 って動くの?

意外と動きます｡

動くもの:

  * TCP Soccket
  * などなど｡

## Perl6 どうやってためしたらいいの?

rakudo のレポジトリを clone して以下をうてばよいです｡

    perl Configure.pl --gen-nqp=master --backends=moar --gen-moar=master

## どの実装で動作確認してるの?

Rakudo + MoarVM ですべて確認してます｡
他でもたぶん動くだろうけど､ MoarVM + Rakudo でだけ動作確認してます｡

## TODO

  * fork って動くのかためしたい
  * Pre-fork の http server を書いてみたい
  * 組み込みメソッドのサンプルとかほしい

## CONTRIBUTIONS

参加したい人はコミットビットあげるので､issues かなにかで言ってください｡

