my @grids = "d13.txt".IO.slurp.split("\n\n");

sub flips(@grid) {
    (0..@grid.elems-1).map({ so (@grid[0..^$_].reverse Zeq @grid[$_..*]).all }) Z* ^Inf;
}

@grids.map({
    my @grid = .lines>>.comb>>.List.List;

    flips(@grid).map(* * 100).sum() + flips([Z] @grid).sum;
}).sum.say;
