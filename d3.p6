my @grid = open('d3.txt').lines.map: *.comb;
my @slopes = ((1, 1), (3, 1), (5, 1), (7, 1), (1, 2));

say [*] @slopes.map({
    my @targets = ((0, $_[0] ... *).map: * % @grid[0].elems) Z (0, $_[1] ... @grid.elems);
    @targets.map({ @grid[$_[1]][$_[0]] }).grep({ $_ eq '#' }).elems;
});
