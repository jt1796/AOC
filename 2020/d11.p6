my @grid = open('d11.txt').lines.map: *.comb.list;

sub nextelem(@grid, $x, $y) {
    my $occs = 0;
    my $arm = @grid.elems;

    for (1..$arm) -> $i {
        last if $y + $i > @grid.end;
        $occs++ if @grid[$y + $i][$x] eq '#';
        last if @grid[$y + $i][$x] ne '.';
    }
    for (1..$arm) -> $i {
        last if $x + $i > @grid[0].end;
        $occs++ if @grid[$y][$x + $i] eq '#';
        last if @grid[$y][$x + $i] ne '.';
    }
    for (1..$arm) -> $i {
        last if $y - $i < 0;
        $occs++ if @grid[$y - $i][$x] eq '#';
        last if @grid[$y - $i][$x] ne '.';
    }
    for (1..$arm) -> $i {
        last if $x - $i < 0;
        $occs++ if @grid[$y][$x - $i] eq '#';
        last if @grid[$y][$x - $i] ne '.';
    }

    for (1..$arm) -> $i {
        last if $y + $i > @grid.end;
        last if $x + $i > @grid[0].end;
        $occs++ if @grid[$y + $i][$x + $i] eq '#';
        last if @grid[$y + $i][$x + $i] ne '.';
    }
    for (1..$arm) -> $i {
        last if $y + $i > @grid.end;
        last if $x - $i < 0;
        $occs++ if @grid[$y + $i][$x - $i] eq '#';
        last if  @grid[$y + $i][$x - $i] ne '.';
    }
    for (1..$arm) -> $i {
        last if $y - $i < 0;
        last if $x + $i > @grid[0].end;
        $occs++ if @grid[$y - $i][$x + $i] eq '#';
        last if @grid[$y - $i][$x + $i] ne '.';
    }
    for (1..$arm) -> $i {
        last if $x - $i < 0;
        last if $y - $i < 0;
        $occs++ if @grid[$y - $i][$x - $i] eq '#';
        last if @grid[$y - $i][$x - $i] ne '.';
    }

    my $empty = @grid[$y][$x] eq "L";
    my $occupied = @grid[$y][$x] eq "#";    
    return "#" if $empty && $occs == 0;
    return "L" if $occupied && $occs >= 5;
    return @grid[$y][$x];
}

sub nextState(@grid) {
    @grid.keys.map(-> $y {
        @grid[$y].keys.map(-> $x {
            nextelem(@grid, $x, $y);
        }).list;
    }).list;
}

my @life = @grid, { nextState($_) } ... Inf;
my @last = (@life Z @life.skip).first({ [eq] $_ });

my @chars = gather @last[0].deepmap: *.take;
say .elems with @chars.grep: * eq '#';
