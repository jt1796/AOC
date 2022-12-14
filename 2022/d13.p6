use MONKEY-SEE-NO-EVAL;

my @markers = [[2],], [[6],];
my @lines = |@markers, |open('d13.txt').lines.grep(*.chars)>>.subst(/<?after \]>\]/, ',]', :g)>>.&EVAL;

sub soln($l, $r) {
    return $l <=> $r if ($l & $r) ~~ Int;                              # both ints
    return soln($l, [$r,]) if $r ~~ Int;                               # one mixed
    return soln([$l,], $r) if $l ~~ Int;                               # one mixed
    my $first = ($l.List Z[&soln] $r.List).first(* != Same);
    return $first if $first ~~ Order;
    return soln($l.elems, $r.elems);
}

say [*] @lines.sort(&soln).grep(* eq @markers.any, :k).map: * + 1;
