my @input = "d14.txt".IO.lines;
my @chain = @input[0].comb;
my @rules = @input.skip(2)>>.split(" -> ");

sub hc($_) {
    my $mid = @rules.first(-> @r { @r.[0] eq .key })[1];
    .key.substr(0, 1)~$mid => .value, $mid~.key.substr(1, 1) => .value;
}

my $seq = ((@chain «~« @chain.skip).Bag, { [⊎] .map(&hc).Bag } ... ∞);
say .values.max - .values.min with [⊎] $seq[40].map({ .key.substr(0, 1) => .value });
