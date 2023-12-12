use experimental :cached;

my @lines = "d12.txt".IO.lines>>.split(" ");

sub groupcount($str) {
    $str ~~ m:g/(\#+)\./;
    $/.map(*[0].Str.chars);
}

sub count($l, $r, @expected) is cached {
    sub countInner($l, $r) {
        my @gc = groupcount($l);

        return 0 unless (@expected Zeq @gc).all;
        return 1 if $r eq "" and @expected eq @gc;
        return 0 if $r eq "";

        my ($f, @rem) = $r.comb;

        if $f eq "?" {
            my @newgc = groupcount($l ~ '.');
            if not (@expected Zeq @newgc).all or @newgc.elems > @expected.elems {
                return countInner($l ~ "#", @rem.join);
            }

            return count('', @rem.join, @expected.skip(@newgc.elems)) + countInner($l ~ "#", @rem.join);
        } else {
            return countInner($l ~ $f, @rem.join);
        }
    }

    countInner($l, $r);
}

sub explode($line) {
    ($line[0] xx 5).join("?"), ($line[1] xx 5).join(',')
}

say @lines.map(&explode).map({ count('', .[0]~'.', .[1].comb(/\d+/)) }).sum;
