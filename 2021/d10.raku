my @lines = "d10.txt".IO.lines>>.comb;
my %pairs = '{' => '}', '[' => ']', '(' => ')', '<' => '>';
my %costs = '{' => 3, '[' => 2, '(' => 1, '<' => 4;

say .grep(* > 0).sort.[*/2] with @lines.map: sub m($_) {
    my $stack = [];

    .map: {
        if %pairs{$_} {
            $stack.push($_);
        } else {
            $stack.elems or return 0;
            (%pairs{$stack.pop()} eq $_) or return 0;
        }
    }

    return reduce {$^a * 5 + $^b}, ($stack.reverse.map: { %costs{$_} });
}
