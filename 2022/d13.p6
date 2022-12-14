use MONKEY-SEE-NO-EVAL;

my @markers = [[2],], [[6],];
my @lines = |@markers, |open('d13.txt').lines.grep(*.chars)>>.subst(/<?after \]>\]/, ',]', :g)>>.&EVAL;

sub soln($l, $r) {
    if ($l & $r) ~~ Int {
        return $l < $r if $l != $r;
        return Nil;
    }
    return soln($l, [$r,]) if $r ~~ Int;
    return soln([$l,], $r) if $l ~~ Int;
    my $first = ($l.List Z[&soln] $r.List).first(* ~~ Bool);
    return $first if $first ~~ Bool;
    return soln($l.elems, $r.elems);
}

say [*] @lines.sort(&soln).reverse.grep(* eq @markers.any, :k).map: * + 1;
