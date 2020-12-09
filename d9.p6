my @input = open('d9.txt').lines.map: * + 0;

my $num = 15353384;

(^@input).map({
    my $start = $_;
    INNER: for ($start^...^@input) {
        my $sum = @input[$start...$_].sum;
        if $num == $sum {
            say @input[$start...$_].min + @input[$start...$_].max;
            die;
        };

        last INNER if $sum > $num;
    }
});
