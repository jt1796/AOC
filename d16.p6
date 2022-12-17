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

my $max = 0;

# smarter caching. dont keep track of accum or pressure?

sub search($loc, $pressure, $accum, $time, $remaining) {
    return -Inf if $time > 31;
    return $accum if $time == 31;
    return $accum unless $remaining;

    # branch and bound
    my $bnbdist = $remaining.keys.map({ %costs{($loc, $_).Str} }).min;
    my $bnb = $accum + $accum * (32 - $time) + $remaining.keys.map({ %weights{$_} * (32 - $time - $bnbdist) }).sum;
    say $bnb;
    return $accum if $bnb <= $max;

    #do nothing and return
    my @options = ($pressure, );

    if $remaining{$loc} {
        #open valve
        @options.push: search($loc, $pressure + %weights{$loc}, $accum + $pressure, $time + 1, $remaining (-) $loc);
    } else {
        # go somewhere else
        $remaining.keys.map(-> $n {
            my $travel = %costs{($loc, $n).Str};
            @options.push: search($n, $pressure, $accum + $travel * $pressure, $time + $travel, $remaining);
        });
    }

    if @options.max > $max {
        $max = @options.max;
        say $max;
    }

    return @options.max;
}

say search("AA", 0, 0, 0, @vertices.Set);

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

# 1651 soln