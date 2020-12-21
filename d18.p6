sub eval($evalexpr) {
    my $input = S:g/\s// with $evalexpr;

    grammar Calculator {
        token TOP { <expr> }
        token num { \d+ }
        token expr { <term> ['*' <term>]* }
        token term { <factor> ['+' <factor>]* }
        token factor { [<num>] | ['(' <expr> ')'] }
    }

    class Compute {
        method TOP($/) { make $<expr>.made }
        method expr($/) { make [*] $<term>.map: *.made }
        method term($/) { make [+] $<factor>.map: *.made }
        method factor($/) { make $<num> ?? $<num>.Str !! $<expr>.made }
    }

    Calculator.parse($input, actions => Compute).made;
}

open('d18.txt').lines.map({ eval($_) }).sum.say;