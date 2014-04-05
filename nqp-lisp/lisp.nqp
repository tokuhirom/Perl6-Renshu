# NQP で実装された簡単な LISP っぽいものです｡
#
# AST をだす
#
#   nqp-m eg/lisp.nqp --target=ast

use NQPHLL;

# パーサーです
grammar SakuraLisp::Grammar is HLL::Grammar {
    token TOP {
        :my $*CUR_BLOCK := QAST::Block.new(QAST::Stmts.new());
        :my $*TOP_BLOCK   := $*CUR_BLOCK;
        ^ ~ $ <sexplist>
            || <.panic('Syntax error')>
    }

    token num { \d+ }
    token op { '+' | '-' | '*' | '/' | 'print' | 'say' }
    rule func { '(' <op> <exp>* ')' }
    rule exp { <func> | <num> }
    rule sexplist { <exp>* }
}

class SakuraLisp::Actions is HLL::Actions {
    method TOP($/) {
        $*CUR_BLOCK.push($<sexplist>.ast);
        make QAST::CompUnit.new( $*CUR_BLOCK );
    }

    method sexplist($/) {
        my $stmts := QAST::Stmts.new( :node($/) );

        # $<exp> ってなんだっけ?
        if $<exp> {
            for $<exp> {
                $stmts.push($_.ast)
            }
        }

        # make で結果を返す
        make $stmts;
    }

    method exp($/) {
        if $<num> {
            make QAST::IVal.new(:value(+$/.Str));
        } elsif $<func> {
            make $<func>.ast;
        } else {
            nqp::die("Oops");
        }
    }

    method func($/) {
        if $<op> eq "+" {
            my $ast := QAST::IVal.new(:value(0));
            for $<exp> {
                $ast := QAST::Op.new(:op<add_n>, $ast, $_.ast);
            }
            make $ast;
        } elsif $<op> eq "-" {
            my $ast := (
                nqp::elems($<exp>) <= 1
                ?? QAST::IVal.new(:value(0))
                !! nqp::shift($<exp>).ast
            );
            for $<exp> {
                $ast := QAST::Op.new(:op<sub_n>, $ast, $_.ast);
            }
            make $ast;
        } elsif $<op> eq "*" {
            my $ast := QAST::IVal.new(:value(1));
            for $<exp> {
                $ast := QAST::Op.new(:op<mul_n>, $ast, $_.ast);
            }
            make $ast;
        } elsif $<op> eq "/" {
            if $<exp> >= 2 {
                my $ast := nqp::shift($<exp>).ast;
                for $<exp> {
                    $ast := QAST::Op.new(:op<div_n>, $ast, $_.ast);
                }
                make $ast;
            } else {
                nqp::die("Wrong number of arguments for '/'");
            }
        } elsif $<op> eq "say" {
            my $stmts := QAST::Stmts.new( :node($/) );
            for $<exp> {
                $stmts.push(
                    QAST::Op.new(
                        :op<say>,
                        $_.ast
                    )
                );
            }
            make $stmts;
        } elsif $<op> eq "print" {
            my $stmts := QAST::Stmts.new( :node($/) );
            for $<exp> {
                $stmts.push(
                    QAST::Op.new(
                        :op<print>,
                        $_.ast
                    )
                );
            }
            make $stmts;
        } else {
            nqp::die("Unknown function name: " ~ $<op>);
        }
    }
}

# これはからっぽでいいみたい｡
#
# HLL::Compiler の定義は src/HLL/Compiler.nqp  にあります｡
class SakuraLisp::Compiler is HLL::Compiler {
    has $!backend;

    # REPL モードのときに表示するプロンプト
    method interactive_prompt() { 'lisp> ' }

    # REPL モードのときに､評価結果を表示する
    method interactive_result($value) {
        nqp::say(">>> " ~ ~$value)
    }

    # 評価する｡なぜか MoarVM んときに -e とかファイルからとかの読み込みがうまくいかないという
    # 謎現象が起きておりまして､とりあえずのワークアラウンドを入れている｡
    # どうしたらいいのかよくわからん｡
    method eval($code, *@args, *%adverbs) {
        my $output;
        $!backend := self.default_backend();

        if (%adverbs<profile-compile>) {
            $output := $!backend.run_profiled({
                self.compile($code, :compunit_ok(1), |%adverbs);
            });
        }
        else {
            $output := self.compile($code, :compunit_ok(1), |%adverbs);
        }

        if $!backend.is_compunit($output) && %adverbs<target> eq '' {
            my $outer_ctx := %adverbs<outer_ctx>;
            $output := $!backend.compunit_mainline($output);
            if nqp::defined($outer_ctx) {
                nqp::forceouterctx($output, $outer_ctx);
            }

            if (%adverbs<profile>) {
                $output := $!backend.run_profiled({ $output(|@args) });
            }
            elsif %adverbs<trace> {
                $output := $!backend.run_traced(%adverbs<trace>, { $output(|@args) });
            }
            else {
                nqp::shift(@args); # ← これがワークアラウンド
                $output := $output(|@args);
            }
        }

        $output;
    }
}

sub MAIN(*@ARGS) {
    # コンパイラを設定します｡
    my $comp := SakuraLisp::Compiler.new();
    $comp.language('lisp');
    # グラマーを設定
    $comp.parsegrammar(SakuraLisp::Grammar);
    # アクションを設定
    $comp.parseactions(SakuraLisp::Actions);

    # ベーシックな挙動をして欲しい場合は command_line メソッドを呼べばOKです｡
    $comp.command_line(@ARGS, :encoding('utf8'));
}

