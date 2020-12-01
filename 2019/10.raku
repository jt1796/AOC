my @grid = slurp('10.txt').lines().map: *.comb(/./).eager;
my @coords = ^@grid.elems X ^@grid[0].elems;
my @markers = @coords.grep: { @grid[$_[0]][$_[1]] eq '#' };

sub slope-dir-between([$x0, $y0], [$x1, $y1]) {
    my $dy = ($y1 - $y0);
    my $dx = ($x1 - $x0);
    my $correction = 0;
    if $dx.sign == -1 {
        $correction = 180;
    }
    return (atan($dy / $dx) * 180 / pi + $correction + 2*360) % 360;
}

sub bag-markers-in-view($x, $y) {
    @markers.grep({ $_ !eq [$x, $y] }).map({ slope-dir-between([$x, $y], $_) }).unique;
}

sub find-marker-at-angle($x, $y, $angle) {
    @markers.grep({ $_ !eq [$x, $y] }).grep({ $angle =~= slope-dir-between([$x, $y], $_) }).min({ ( ($x - $_[0])**2 + ($y - $_[1])**2).sqrt })
}

sub from-angle-sweep($x, $y) {
    bag-markers-in-view($x, $y).sort({ (-($_ - 180) % 360) }).map({ find-marker-at-angle($x, $y, $_) })
}

# say from-angle-sweep(19, 23, 10)[19];
say from-angle-sweep(19, 23)[199];
