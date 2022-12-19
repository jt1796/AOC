use experimental :cached;

my @grid = "d9.txt".IO.lines>>.comb>>.Int;

sub basin($y, $x) is cached {
    my @nxbor = .grep({ @grid[.[0]][.[1]] ~~ Int && @grid[.[0]][.[1]] < @grid[$y][$x] })
        .min({ @grid[.[0]][.[1]] })
        with ((1, 0), (0, 1), (-1, 0), (0, -1)) «<<+>>» (($y, $x), *);

    return $x~'!'~$y if @grid[$y][$x] == 9 or @nxbor[0] ~~ Inf;
    return basin(|@nxbor[0]);
}

say [*] .Bag.values.sort.reverse[0..2] with (^@grid.elems X ^@grid[0].elems).map: { basin(|$_) };