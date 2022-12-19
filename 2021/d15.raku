use PriorityQueue;

my @grid = "d15.txt".IO.lines>>.comb>>.Int;

for ^2 {
    my @base = ^5 .map({ $_ xx +@grid[0] }).flat;
    @grid = @grid.map: * <<+>> @base;
    @grid = @grid.map: { .map({ ($_ - 1) % 9 + 1 }).List };
    @grid = [Z] @grid;
}

my $p = PriorityQueue.new(:cmp({ $^a[2] < $^b[2] }));
$p.push((0, 0, -1 * @grid[0][0]),);

my %minseen is default(Inf);

while True {
    my $frontier = $p.shift();
    my ($x, $y, $w, %path) = $frontier;

    say $w if $++ % 1000 eq 0;
    next if ($y|$x) > @grid.end or ($y|$x) < 0;

    my $amt = @grid[$y][$x] + $w;
    say $amt and die if ($y & $x) eq @grid.end;
    next if %minseen{ $x~'/'~$y } <= $amt;
    %minseen{ $x~'/'~$y } = $amt;

    $p.push(($x - 1, $y + 0, $amt));
    $p.push(($x + 1, $y + 0, $amt));
    $p.push(($x - 0, $y - 1, $amt));
    $p.push(($x + 0, $y + 1, $amt));
}

# two points at same point? Purge the one thats not the smallest
# or keep track of min seen at a point

# 315
# 2835 too high
