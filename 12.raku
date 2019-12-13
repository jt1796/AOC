my @moons = slurp('12.txt').comb(/"-"?\d+/).batch(3);
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

loop() for ^10;
say [+] ((@moons Z @velocities).map({ energy($_[0]) * energy($_[1]) }));