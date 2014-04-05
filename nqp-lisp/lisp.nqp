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
    rule func { '(' <op> <exp>+ ')' }
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
            if nqp::elems($<exp>) == 2 {
                make QAST::Op.new(:op<add_n>, $<exp>[0].ast, $<exp>[1].ast);
            } else {
                # support (+ 3 2 4)
                nqp::die("Bad argument count for '+'");
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
            nqp::die("Oops");
        }
    }
}

# これはからっぽでいいみたい｡
class SakuraLisp::Compiler is HLL::Compiler {
}

sub MAIN(*@ARGS) {
    my $comp := SakuraLisp::Compiler.new();
    $comp.language('lisp');
    $comp.parsegrammar(SakuraLisp::Grammar);
    $comp.parseactions(SakuraLisp::Actions);
    $comp.command_line(@ARGS, :encoding('utf8'));
}

