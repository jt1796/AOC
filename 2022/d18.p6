my @lines = open('d18.txt').lines>>.comb(/\d+/)>>.Int;
my %droplet = @lines.map(*.Str => True);

my @nxbors = ((0,0,1), (0,0,-1), (0,1,0), (0,-1,0), (1,0,0), (-1,0,0));

my @bounds = ([Z] @lines).map({(.min - 1)...(.max + 1)});
my @corner = (@bounds>>.[0]);
my @frontier = (@corner,);

my %steam;
while @frontier {
    my @newfrontier = @frontier
        .map({ |(($_,*) «>>+<<» @nxbors) })
        .grep({ ! %steam{.Str} })
        .grep({ ! %droplet{.Str} })
        .grep({ (.list Z⊆ @bounds ).all })
        .unique(with => *.Str eq *.Str);
    %steam{.Str} = True for @frontier;

    @frontier = @newfrontier;
}

say @lines.map({
    (($_,*) «>>+<<» @nxbors).map({so %steam{.Str}}).sum;
}).sum;
