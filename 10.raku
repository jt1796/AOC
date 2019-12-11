my @grid = slurp('10.txt').lines().map: *.comb(/./).eager;
my @coords = ^@grid.elems X ^@grid[0].elems;
my @markers = @coords.grep: { @grid[$_[0]][$_[1]] eq '#' };

sub slope-dir-between([$x0, $y0], [$x1, $y1]) {
    my $dy = ($y1 - $y0);
    my $dx = ($x1 - $x0);
    return 9999 if  $dy eq 0 and $dx eq 0;
    if $dx eq 0 {
        return ~[Inf, $dy.sign]
    }
    my $m = $dy / $dx;
    ~[$m, $dx.sign]
}

sub markers-in-view([$x, $y]) {
    # @markers.map({ slope-dir-between([$x, $y], $_) }).Bag.say;
    [+] -1, |@markers.map({ slope-dir-between([$x, $y], $_) }).Bag.keys.elems;
}

say @markers.map({ markers-in-view($_) }).max;