my @lines= "d11.txt".IO.lines>>.comb>>.Int>>.Array;

my @tiles = (^@lines.elems .rotor(3 => -2)) XX (^@lines[0].elems .rotor(3 => -2));

for ^Inf {
    for ^@lines.elems -> $y {
        for ^@lines[$y].elems -> $x {
            @lines[$y][$x]++;
        }
    }

    my $flashed = True;
    my %fset;
    while $flashed {
        $flashed = False;
        for @tiles {
            my ($x, $y) = .[*/2];
            if @lines[$x][$y] > 9 and not %fset{[$y, $x].Str} {
                %fset{[$y, $x].Str} = True;
                $flashed = True;
                @lines[.[0]][.[1]]++ for .list;
            }
        }
    }

    my $flashes = 0;
    for ^@lines.elems -> $y {
        for ^@lines[$y].elems -> $x {
            if @lines[$y][$x] > 9 {
                $flashes++;
                @lines[$y][$x] = 0;
            }
        }
    }

    say $flashes;
    .say for @lines;
    if $flashes == @lines.elems * @lines[0].elems {
        say $_ and die;
    }
}

