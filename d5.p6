my @input = open('d5.txt').lines;

my @nums = @input.map({
    s:g/B|R/1/;
    s:g/F|L/0/;
    my $first = .comb()[^7].join().parse-base(2);
    my $second = .comb()[*-3..*].join().parse-base(2);

    $first * 8 + $second;
}).sort;

my $min = min @nums;
my $max = max @nums;

say ($min..$max) (-) @nums;