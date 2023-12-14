my @grids = "d13.txt".IO.slurp.split("\n\n").map({ .lines>>.comb>>.Array.Array });

my %mut = '.' => '#', '#' => '.';

sub hyperflips(@grid) {
    gather for ^@grid -> $r {
        for ^@grid[$r] -> $c {
            @grid[$r][$c] = %mut{@grid[$r][$c]};
            .take for flips(@grid);
            @grid[$r][$c] = %mut{@grid[$r][$c]};
        }
    }
}

sub flips(@grid) {
    (^@grid).map({ so (@grid[$_^...0] Zeq @grid[$_..*]).all }) Z* ^Inf;
}

@grids.map(-> @grid {
    100 * (hyperflips(@grid)     (-) flips(@grid)).keys.sum
       || (hyperflips([Z] @grid) (-) flips([Z] @grid)).keys.sum;

}).sum.say;
