my @reactions = slurp('14.txt').lines.map({ m:g/\w+/.map({ .Str }) });
my %needs is default(0) = 'FUEL' => 1;

sub apply-reaction($need) {
    my @reaction = @reactions.first({ $_[* - 1] eq $need }).rotor(2);
    %needs{$_[1]} += $_[0] for @reaction;
    %needs{ $need } -= 2 * @reaction[* - 1][0];
}

sub get-next-need() {
    %needs.keys.first({ $_ !eq 'ORE' and  %needs{ $_ } > 0 });
}

while (get-next-need()) {
    apply-reaction(get-next-need());
}

say %needs;
say %needs<ORE>