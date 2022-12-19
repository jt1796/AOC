my @input = "d13.txt".IO.lines;

my @nums = @input.grep(* ~~ /\d+\,\d+/)>>.comb(/\d+/)>>.Array;
my @folds = @input.grep: * ~~ /fold/;

for @folds {
    my ($dim, $val) = .words.first(*.index('=')).split('=');
    my $coord = $dim eq 'x' ?? 0 !! 1;

    for @nums {
        .[$coord] = (.[$coord] > $val) ?? (2 *  $val - .[$coord]) !! (.[$coord]);
    }

    @nums = @nums.grep({ .[$coord] < $val });
}

for ^10 -> $x {
    for ^50 -> $y {
        print @nums.first(($y, $x)) ?? '#' !! ' ';
    }
    say '';
}