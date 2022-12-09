my @rope = 0 xx 10;

my %dirs =
    U => i,
    D => -i,
    L => -1,
    R => 1;

my %locs;

my @cand = (-1, 0, 1) X+ (-i, 0, i);

for open('d9.txt').lines.map({[xx] .words}).flat -> $dir {
    @rope[0] += %dirs{$dir};
    for @rope.keys.skip {
        if (@rope[$_] - @rope[$_-1]).abs >= 2 {
            @rope[$_] += @cand.min((@rope[$_-1] - @rope[$_] - *).abs);
        }
    }
    %locs{@rope[*-1]} += 1;
}

say %locs.elems;