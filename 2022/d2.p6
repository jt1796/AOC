my $wins = 'A_B B_C C_A';
my $loss = $wins.flip;
my @opts = <A B C>;

my @input = open('d2.txt').lines.map({ |(.[0] ~ "_", .[2]) with .comb })
    .map(-> $pre, $tok {
        $pre ~ (given $tok {
            when "X" { @opts.first({$loss.contains($pre ~ $_)}) }
            when "Y" { $pre.comb[0] }
            when "Z" { @opts.first({$wins.contains($pre ~ $_)}) }
        })
    });

say [+] [Z+]
    .map({ (.flip eq $_) ?? 3 !! ($wins.contains($_)) ?? 6 !! 0 }),
    .map({ ' ABC'.index(.comb[2]) })
    with @input;
