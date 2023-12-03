my @input = "d3.txt".IO.lines>>.comb>>.List;

my %words;

sub nearby($x, $y) {
    (($x, $y), *) <<>>+<<>> ((-1, 0, 1) X (-1, 0, 1))
}

for ^@input -> $y {
    for @input[$y].join() ~~ m:g/\d+/ {
        my $word = .Int + ($y * 141 + .from + 1)i;
        %words{(($_, $y), )} = $word for .from ..^ .to;
    }
}

@input.kv.map(-> $y, @row {
    |@input[$y].kv.map(-> $x, $v {
        if $v eq '*' {
            my %nears = nearby($x, $y).map(* => 1);
            my @parts = (%nears <<*>> %words).values.unique>>.re;
            @parts.elems eq 2 ?? [*] @parts !! 0;
        }
    });
}).sum.say;
