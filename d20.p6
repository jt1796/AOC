my %tiles;

my @tile;
for open('d20.txt').lines {
    if (m/Tile/) {
        %tiles{ m/\d+/.Str } := @tile.list;
    }

    if (/Tile/ ^ff^ "") {
        @tile.push($_.comb.list);
    }

    if ($_ eq "") {
        @tile := [];
    }
}

my $dim = %tiles.elems.sqrt;
my $names = %tiles.keys.Set;

#rotating and flipping
sub flip(@tile) {
    @tile,
    @tile.reverse.list,
    @tile.map(*.reverse.list),
    @tile.reverse.map(*.reverse.list);
}

sub arrange($name) {
    my @tile = %tiles{ $name };
    |flip(@tile), |flip([Z] @tile);
}

sub tops(@tile) {
    @tile[0].join('');
}

sub bots(@tile) {
    @tile.tail.join('');
}

sub lefts(@tile) {
    @tile.map({ .[0] }).join('');
}

sub rights(@tile) {
    @tile.map({ .[* - 1] }).join('');
}

sub findsoln(%gridsofar, @used, $x, $y) {
    say ($x, $y);
    if $y == $dim {
        return @used;
    }
    return False if ($y, $x).any >= $dim;
    my @avail = .keys with $names (-) @used;

    for @avail -> $key {
        for arrange($key) -> @grid {
            if ($x > 0) {
                my @left := %gridsofar{ ($x - 1, $y).Str };
                next if rights(@left) ne lefts(@grid);
            }
            if ($y > 0) {
                my @top := %gridsofar{ ($x, $y - 1).Str };
                next if bots(@top) ne tops(@grid);
            }

            my %newgrid = %gridsofar;
            my @newused = @used.Slip, $key;
            %newgrid{ ($x, $y).Str } := @grid;
            if $x == $dim - 1 {
                my $c = findsoln(%newgrid, @newused, 0, $y + 1);
                return $c if $c;
            }
            my $c = findsoln(%newgrid, @newused, $x + 1, $y);
            return $c if $c;
        }
    }

    return False;   
}

my @soln := findsoln({}, (), 0, 0);
say @soln;
say @soln[0, $dim, * - $dim, *-1];
say [*] @soln[0, $dim - 1, * - $dim, *-1];