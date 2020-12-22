my @grammar = gather for open('d19.txt').lines {
    take $_ if "start" ^ff^ "";
}

my @text = gather for open('d19.txt').lines {
    take $_ if "" ^ff *;
}

my %gramnear;
@grammar
    .map({ .split(": ") })
    .map({ %gramnear{ .[0] } = .[1].split("|").map({ .comb(/<alnum>+/) }) })
    .eager;

say @grammar.raku;
say @text.raku;
say %gramnear.raku;

sub matches($production, $text) {
    my $productions = %gramnear{ $production };
    if $productions[0][0] ~~ m/<alpha>/ {
        if $text.substr(0, 1) eq $productions[0][0] {
            return [$text.substr(1)];
        } else {
            return [];
        }
    }

    return $productions.map(-> @prod {
        reduce(-> @list, $prod { @list.map({matches($prod, $_)}).flat }, ([$text], @prod.Slip));
    }).flat.eager;
}

sub isvalid($text) {
    matches("0", $text).grep("").elems > 0;
}

@text.map({ isvalid($_) }).grep({ $_ }).elems.say;
