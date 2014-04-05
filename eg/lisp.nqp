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
    token op { '+' | '-' | '*' | '/' }
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
        make QAST::Op.new(:op<print>, QAST::IVal.new(:value(5963)));
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

