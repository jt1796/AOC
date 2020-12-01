sub color($l, $r) {
    2 eq $l ?? $r !! $l;
}

sub infix:<LYR>(@l, @r) {
    (@l Z @r).map({ color(|$_) });
}

.join.say for ([LYR] slurp('8.txt').comb(/<digit>/).rotor(25 * 6)).map({$_ eq 0 ?? " " !! "X"}).rotor(25);