my @grids = "d13.txt".IO.slurp.split("\n\n");

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
    (0..@grid.elems-1).map({ so (@grid[0..^$_].reverse Zeq @grid[$_..*]).all }) Z* ^Inf;
}

@grids.map(sub ($_) {
    my @grid = .lines>>.comb>>.Array.Array;

    my @horizontal = flips(@grid);
    my @vertical = flips([Z] @grid);

    return 100 * (hyperflips(@grid) (-) @horizontal).keys.sum
        || (hyperflips([Z] @grid) (-) @vertical).keys.sum;

}).sum.say;
