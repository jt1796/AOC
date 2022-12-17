my @input = open('d16.txt').lines>>.comb(/<digit>+|(<upper> ** 2)/);

my %weights;
my @vertices;
my %costs;

for @input {
    my ($where, $howmuch, @to) = $_;
    @vertices.push: $where;
    %weights{$where} = $howmuch;
    %costs{($where, $_).Str} = 1 for @to;
    %costs{($where, $where).Str} = 0;
}

%costs{.Str} = min(%costs{.Str}, Inf) for (@vertices X @vertices);
%costs = pow(&update, %costs).tail;

my @zerovalves = @vertices.grep({ %weights{$_} == 0 });
@vertices = (@vertices (-) @zerovalves).keys;

my %cache;

sub search($loc, $time, $remaining) {
    return -Inf if $time >= 31;

    my $key = ($loc, $time, $remaining.keys.sort).Str;
    return %cache{ $key } if %cache{ $key };

    my @options = (0,);

    if $remaining{$loc} {
        @options.push: %weights{$loc} * (29 - $time) + search($loc, $time + 1, $remaining (-) $loc);
    } else {
        $remaining.keys.map(-> $n {
            @options.push: search($n, $time + %costs{($loc, $n).Str}, $remaining);
        });
    }

    return %cache{ $key } = @options.max;
}

my $i = 0;
say @vertices.combinations.map(-> @a {
    my @b = (@vertices (-) @a).keys;
    say $i++ ~ "         :  " ~ @a ~ " / " ~ @b;
    search("AA", 4, @a.Set) + search("AA", 4, @b.Set);
}).max;

## Helpers ##

sub pow(&f, $i) { $i, { &f($_) } ... *.Str eq *.Str };
sub update(%costs) {
    my %new = %costs;
    for @vertices -> $from { 
        for @vertices -> $to { 
            for @vertices -> $by { 
                %new{($from, $to).Str} = min(%new{($from, $to).Str}, %new{($from, $by).Str} + %new{($by, $to).Str});
            }
        } 
    }
    %new;
}
