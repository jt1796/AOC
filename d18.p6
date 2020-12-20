sub eval($evalexpr) {
    my $input = $evalexpr.flip;

    s:g/\s// with $input;
    s:g/\d+/{$/.flip}/ with $input;
    s:g/\)/\%/ with $input;
    s:g/\(/\)/ with $input;
    s:g/\%/\(/ with $input;

    grammar Calculator {
        token TOP { <expr> }
        token num { \d+ }
        token binop { '+' | '*' }
        token expr { [<expr1> <binop> <expr>] | [<expr1>] }
        token expr1 { ['(' <expr> ')'] | [<num>] }
    }

    class Compute {
        method TOP($/) { make $<expr>.made }
        method expr($/) {
            make $<binop>
            ?? ($<binop>.Str eq '+') ?? ($<expr1>.made + $<expr>.made) !! ($<expr1>.made * $<expr>.made)
            !! $<expr1>.made
        }
        method expr1($/) { make $<num> ?? $<num>.Str !! $<expr>.made }
    }

    return Calculator.parse($input, actions => Compute).made;
}

open('d18.txt').lines.map({ eval($_) }).sum.say;