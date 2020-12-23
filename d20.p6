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

sub stripborder(@tile) {
    @tile[1..*-2].map({ .[1..*-2] });
}

sub findsoln(%gridsofar, @used, $x, $y) {
    say ($x, $y);
    if $y == $dim {
        return %gridsofar;
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

my %soln := findsoln({}, (), 0, 0);
for %soln {
    %soln{ .key } := stripborder(.value);
}

my $picdim = 8 * $dim;
my @pic = .rotor($picdim) with gather for ^$dim -> $y {
    for ^8 -> $innery {
        for ^$dim -> $x {
            for ^8 -> $innerx {
                take %soln{ ($x, $y).Str }[$innery][$innerx];
            }
        }
    }
}

sub monstercoords() {
    (
        (0,  0),
        (1, -1),
        (4, -1),
        (5,  0),
        (6,  0),
        (7, -1),
        (10, -1),
        (11,  0),
        (12, 0),
        (13, -1),
        (16, -1),
        (17, 0),
        (18, 0),
        (18, 1),
        (19, 0),
    )
}

say monstercoords();

my @arrangements := (|flip(@pic), |flip([Z] @pic));
my $monsters = @arrangements.map(-> @arrangement {
    my $monsters = 0;
    for ^$picdim -> $x {
        for ^$picdim -> $y {
            my $possible = monstercoords()
                .map( { $_ >>+<< ($x, $y) } )
                .grep({ 0 <= .all < $picdim })
                .map( { @arrangement[.[1]][.[0]] } )
                .grep({ .all eq "#" })
                .elems;
            
            if ($possible == monstercoords().elems) {
                ($x, $y).say;
                $monsters++;
            }
        }
    }

    say $monsters;
    $monsters;
}).max;

say $monsters;
my $hashes = .sum with gather @pic.deepmap({ take 1 if $_ eq '#' });
say $hashes - $monsters*monstercoords().elems;