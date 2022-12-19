# say ("0b" ~ $_).Int * ("0b" ~ TR/01/10/).Int with ([Z] "d3.txt".IO.lines.map(*.comb)).map(*.sort[*/2]).join();

my @lines = "d3.txt".IO.lines.map: *.comb;

sub find(@lines, $pos, &op) {
    return ("0b" ~ @lines[0].join).Int if @lines.elems <= 1;
    my $common = @lines.map(*.[$pos]).sort[*/2];
    return find(@lines.grep({ &op($_.[$pos], $common) }), $pos + 1, &op);
}

say [*] (&infix:<eq>, &infix:<ne>).map: { find(@lines, 0, $_) }