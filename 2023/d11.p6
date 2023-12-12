my @grid = "d11.txt".IO.lines>>.comb;

sub missings(@grid) {
    @grid.kv.map(-> $k, @v { @v.any eq "#" ?? -1 !! $k }).Bag.keys;
}

my @rmiss = missings(@grid);
my @cmiss = missings([Z] @grid);

my @coords = @grid.kv.map(-> $k, @v { |@v.join.indices("#").map({ $k, $_ }) });
my @pairs = @coords X @coords;

sub dist((@l, @r)) {
    (@rmiss ∩ (@l[0] minmax @r[0])) * (1000000 - 1) +
    (@cmiss ∩ (@l[1] minmax @r[1])) * (1000000 - 1) +
    (@l >>-<< @r)>>.abs.sum;
}

say @pairs.map(&dist).sum / 2;