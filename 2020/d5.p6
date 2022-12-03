my @input = open('d5.txt').lines;

my @nums = @input.map({
    s:g/B|R/1/;
    s:g/F|L/0/;
    .parse-base(2);
}).sort;

my $min = min @nums;
my $max = max @nums;

say ($min..$max) (-) @nums;
