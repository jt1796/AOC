sub tell-ores($fuel) {
    my @reactions = slurp('14.txt').lines.map({ m:g/\w+/.map({ .Str }) });
    my %needs is default(0) = 'FUEL' => $fuel;

    sub apply-reaction($need) {
        my @reaction = @reactions.first({ $_[* - 1] eq $need }).rotor(2);
        my $times = (%needs{ $need } / @reaction[* - 1][0]).ceiling;
        %needs{$_[1]} += $_[0] * $times for @reaction[0..*-2];
        %needs{ $need } -= $times * @reaction[*-1][0];
    }

    sub get-next-need() {
        %needs.keys.first({ $_ !eq 'ORE' and  %needs{ $_ } > 0 });
    }

    while (get-next-need()) {
        apply-reaction(get-next-need());
    }

    %needs<ORE>;
}

say tell-ores(1);