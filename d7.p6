my @input = open('d7.txt').lines.map: *.comb(/(\d+\s)?\w+\s(\w+)\sbag(s)?/).list;

my %bagmap;

@input.map({
    my @terms = $_.skip.list;
    my $holder = S/bags/bag/ with $_[0];
    %bagmap{$holder} = @terms.map({S/bags/bag/ with $_}).list;
});

sub findbags($name) {
    my @children = %bagmap{$name}.list;
    return [+] @children.map({
        my @words = .words;
        my $nextname = @words.tail(* - 1).join(" ");
        .contains("no other") ?? 0 !! (@words[0] + @words[0] * findbags($nextname));
    });
}

say findbags("shiny gold bag");
