my %dirs = 'U' => (-1, 0), 'D' => (1, 0), 'L' => (0, -1), 'R' => (0, 1);

my @input = "d18.txt".IO.lines>>.split(' ');

my @steps = @input.map({ .[0] xx .[1] }).flat.map({ %dirs{ $_ } });

my %bounds = @steps.produce(-> @a, @b { @a >>+<< @b }).map(*.join("_") => True).Hash;

my %outer;

my $r = 405;

sub bfs($x, $y) {
    return unless -$r <= ($x,$y).all <= $r;
    return if %outer{ ($x,$y).join("_") }:exists or %bounds{ ($x,$y).join("_") }:exists;

    %outer{ ($x,$y).join("_") } = True;

    bfs(.[0], .[1]) for %dirs.values.map({ $_ >>+<< ($x,$y) });
}

bfs(-$r, -$r);

say ((2 * $r + 1) ** 2) - %outer.elems;
