my @wall = open('d14.txt').lines>>.comb(/\d+/)>>.Int>>.rotor(2).map({
    .rotor(2 => -1).map({ .List.Slip with (.[0][0]...(.[1][0])) X (.[0][1]...(.[1][1])) }).Slip;
});

my $sands = 0;
my $floor = @wall>>.[1].max + 2;
my %cache;
%cache{$_} = True for @wall.map(*.join("_"));

while True {
    my @sand = (500, 0);
    die "done " ~ $sands if %cache{"500_0"};
    while True {
        if (@sand[1] >= $floor - 1) {
            $sands++;
            %cache{@sand.join("_")} = True;
            last
        }

        if !(%cache{@sand[0] ~ "_" ~ @sand[1].succ}) {
            @sand = (@sand[0], @sand[1].succ);
        } elsif !(%cache{@sand[0].pred ~ "_" ~ @sand[1].succ}) {
            @sand = (@sand[0].pred, @sand[1].succ);
        } elsif !(%cache{@sand[0].succ ~ "_" ~ @sand[1].succ}) {
            @sand = (@sand[0].succ, @sand[1].succ);
        } else {
            $sands++;
            %cache{@sand.join("_")} = True;
            last;
        }
    }
}
