my @grid = open('d8.txt').lines.map: *.comb.Array;
my @viz = @grid.map: *.map({ 1 }).Array;

for ^4 {
    for @grid.keys -> $row {
        for @grid[0].keys -> $col {
            my @pre = [\max] @grid[$row][^$col].reverse;
            my $prehas = so @pre.first(* >= @grid[$row][$col]);

            @viz[$row][$col] *= $prehas + @pre.grep(* < @grid[$row][$col]);
        }
    }
    @grid = .map: *.reverse.Array with [Z] @grid;
    @viz = .map: *.reverse.Array with [Z] @viz;
}

say @viz>>.max.max;