use MONKEY-SEE-NO-EVAL;

my @markers = [[2],], [[6],];
my @lines = |@markers, |open('d13.txt').lines.grep(*.chars)>>.subst(/<?after \]>\]/, ',]', :g)>>.&EVAL;

sub soln($l, $r) {
    given ($l, $r) {
        when Int, Int { $l <=> $r }
        when Int, Array { soln([$l,], $r) }
        when Array, Int { soln($l, [$r,]) }
        when Array, Array { 
            my $first = ($l.List Z[&soln] $r.List).first(* != Same);
            return $first if $first ~~ Order;
            return soln($l.elems, $r.elems);
        }
    }
}

say [*] @lines.sort(&soln).grep(* eq @markers.any, :k).map: * + 1;
