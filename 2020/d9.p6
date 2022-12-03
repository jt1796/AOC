my @input = open('d9.txt').lines.map: * + 0;

my $num = 15353384;

(^@input).map({
    my $start = $_;
    INNER: for ($start^..^@input.elems) -> $end {
        my $sum = @input[$start..$end].sum;
        if $num == $sum {
            say @input[$start...$end].min + @input[$start...$end].max;
            die;
        };

        last INNER if $sum > $num;
    }
});
