use MONKEY-SEE-NO-EVAL;

my @markers = [[2],], [[6],];
my @lines = |@markers, |open('d13.txt').lines.grep(*.chars)>>.subst(/<?after \]>\]/, ',]', :g)>>.&EVAL;

sub soln($l, $r) {
    return $l ~~ Nil if ($l|$r) ~~ Nil;
    if ($l & $r) ~~ Int {
        return $l < $r if $l != $r;
        return Nil;
    }
    if ($l|$r) ~~ Array {
        my @l = ([$l,], $l)[$l ~~ Array].List;
        my @r = ([$r,], $r)[$r ~~ Array].List;
        my @res = @l Z[&soln] @r;
        my $first = @res.first(* ~~ Bool);
        return $first if $first ~~ Bool;
        return Nil if @l.elems == @r.elems;
        return @r.elems > @l.elems;
    }
}

say [*] @lines.sort(&soln).reverse.grep(* eq @markers.any, :k).map: * + 1;
