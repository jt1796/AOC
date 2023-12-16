my @boxes = ^256 .map({ Array.new });

for "d15.txt".IO.slurp.split(',')>>.split(/[\=|\-]/, :v)>>.Str -> ($pat, $op, $arg) {
    my $hash = (0, |$pat.comb>>.ord).reduce({ 17 * ($^a + $^b) mod 256 });

    if $op eq '-' {
        @boxes[$hash] = @boxes[$hash].grep({ $pat ne .[0] }).Array;
    }

    if $op eq '=' {
        my $existing = @boxes[$hash].first({ $pat eq .[0] });
        if $existing {
            $existing[2] = $arg;
        } else {
            @boxes[$hash].push([ $pat, $op, $arg ]);
        }
    }
}

say @boxes.kv.map(-> $bidx, @box { @box.kv.map(-> $lidx, @lens { (1 + $bidx) * (1 + $lidx) * (@lens[2]) }) }).flat.sum;