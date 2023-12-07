my @input = [Z] "d6.txt".IO.lines>>.comb(/\d+/)>>.join('');

say [*] @input.map(-> ($time, $beat) {
    my $max = $time / 2;
    my @seq = ^Inf Z* ($time, $time - 1 ... *);

    ($max - @seq.first(* > $beat, :k)) * 2 + 1;
});
