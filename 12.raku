my @moons = slurp('12.txt').comb(/"-"?\d+/).batch(3);
my @initials = slurp('12.txt').comb(/"-"?\d+/).batch(3);
my @velocities = @moons.map({ 0, 0, 0 });

sub infix:<$^>(@a, @b) {
    (@b Z[-] @a).map: *.sign;
}

sub infix:<$+>(@a, @b) {
    @a Z[+] @b;
}

sub loop() {
    my @diffs = (@moons X$^ @moons).batch(@moons.elems).map({[$+] $_ });
    @velocities = @velocities Z$+ @diffs;
    @moons = @moons Z$+ @velocities;
}

sub energy(@a) {
    [+] @a.map: *.abs;
}

# loop() for ^10;
# say [+] ((@moons Z @velocities).map({ energy($_[0]) * energy($_[1]) }));

sub loops-till-initial() {
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