# possible idea. The moons are not identical. Loop until each initial moon configuration 
# corresponds to a moon, even if not the same moon. You now know how many loops it takes to
# "reorder" the moons. You can now replay the permutation until you arrive back at the initial state.

my @moons;
my @initials;
my @velocities;

sub setup() {
    @moons = slurp('12.txt').comb(/"-"?\d+/).Array.rotor(3);
    @initials = slurp('12.txt').comb(/"-"?\d+/).rotor(3);
    @velocities = @moons.map({ [0, 0, 0] });
}

sub loop() {
    for ^@moons.elems -> $inner {
        for ^@moons.elems -> $outer {
            for ^@moons[0].elems -> $coord {
                @velocities[$inner][$coord] -= (@moons[$inner][$coord]  -  @moons[$outer][$coord]).sign;
            }
        }
    }

    for ^@moons.elems -> $moon-index {
        for ^@moons[0].elems -> $coord {
            @moons[$moon-index][$coord] += @velocities[$moon-index][$coord];
        }
    }
}


sub loops-till-initial() {
    setup();
    my $loop-ctr = 1;

    my $xend = Nil;
    my $yend = Nil;
    my $zend = Nil;
    until ($xend and $yend and $zend) {
        loop();
        $xend = $loop-ctr if !$xend and @moons[*;0] eq @initials[*;0] and @velocities[*;0] eq (0, 0, 0, 0);
        $yend = $loop-ctr if !$yend and @moons[*;1] eq @initials[*;1] and @velocities[*;1] eq (0, 0, 0, 0);
        $zend = $loop-ctr if !$zend and @moons[*;2] eq @initials[*;2] and @velocities[*;2] eq (0, 0, 0, 0);
        $loop-ctr++;
    }
    say ($xend, $yend, $zend);
    ($xend, $yend, $zend);
}

say [lcm] loops-till-initial();

# 1575501928 too low