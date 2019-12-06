use experimental :cached;

my regex planet { \w+ };
my @input = slurp('6.txt').comb(/<planet>/).reverse.batch(2);
my @planets = slurp('6.txt').comb(/<planet>/).unique;

sub orbits($of) is cached {
    my @matches = @input[].grep({ $of eq $_[0] });
    [$of, |@matches.map: { |orbits($_[1]) }]
}

my @you = reverse orbits("YOU");
my @san = reverse orbits("SAN");
my $common = (@you Z @san).grep({ $_[0] eq $_[1] }).elems;

say @you.elems + @san.elems - 2 * $common - 2;

# say [+] @planets.map: { orbits($_) } part1
