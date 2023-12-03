my @input = "d3.txt".IO.lines>>.comb>>.List;

my %hot;
my %words;

sub nearby($x, $y) {
    (($x, $y), *) <<>>+<<>> ((-1, 0, 1) X (-1, 0, 1))
}

for ^@input -> $y {
    for @input[$y].join() ~~ m:g/\d+/ {
        my $word = .Int + ($y * 141 + .from + 1)i;
        %words{(($_, $y), )} = $word for .from ..^ .to;
    }
    for ^@input[$y] -> $x {
        %hot{nearby($x, $y)} = (1, 1 ... ∞) unless @input[$y][$x] ~~ /\d|\./;
    }
}

(%hot <<*>> %words).values.unique>>.re.sum.say;
