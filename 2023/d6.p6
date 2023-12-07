my @input = [Z] "d6.txt".IO.lines>>.comb(/\d+/);

sub mkseq($time) {
    (0, 1, 2 ... *) Z* ($time, $time - 1 ... *);
}

sub findmax($seq, $l, $r) {
    my $m = (($l + $r) / 2).Int;
}

say [*] @input.map(-> ($time, $beat) {
    my $max = $time / 2;

    ($max - mkseq($time).first(* > $beat, :k)) * 2 + 1;
});
