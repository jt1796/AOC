sub round(@nums) {
    my @copy;
    my $sum = 0;
    for ^(@nums.elems) -> $idx {
        $sum += @nums[$idx];
        @copy[$idx] = $sum % 10;
    }
    @copy;
}

round([5, 3, 6, 7]).say;

my $multiple = 10000;
my @nums = (slurp('16.txt') x $multiple).comb();

my $where = @nums[0..6].join;
$where.say;
@nums = @nums[$where..*].reverse;

@nums = round(@nums) for ^100;
say @nums.reverse[0..100];

