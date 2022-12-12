my @grid = open('d12.txt').lines.map(*.comb().Array);

my &coords = sub ($e) { @grid.map(*.first($e, :k)).first(Int, :kv) };
my &letter = &{ @grid[.[0]][.[1]] }
my @start = &coords("S");
my @exit = &coords("E");

@grid[@start[0]][@start[1]] = 'a';
@grid[@exit[0]][@exit[1]] = 'z';

my @frontier = (|@exit, 0),;
my @dirs = ((0,1),(0,-1),(1,0),(-1,0));
my %seen;

while @frontier {
    my $popped = @frontier.shift();
    my $here = $popped.head(2);
    next if %seen{$here};
    %seen{$here} = $popped.tail;

    say $popped.tail and die if &letter($here) eq 'a';

    my @nexts = @dirs
        .map({ $_ >>+<< $here })
        .grep({ !%seen{$_} })
        .grep({ 0 <= .[0] < @grid and 0 <= .[1] < @grid[0] })
        .grep({ ord(&letter($_)) >= ord(&letter($here)) - 1 });

    @frontier.push((|$_, $popped.tail + 1)) for @nexts;
}
