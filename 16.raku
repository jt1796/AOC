sub pattern($n) {
    (0 xx $n, 1 xx $n, 0 xx $n, -1 xx $n).flat.List.rotate(1);
}

sub infix:<@+%>(@a, @b) {
    $_.abs % 10 with [+] (^@a.elems).map({ @a[$_] * @b[$_ % *] });
}

sub FFT(@nums) {
    "fft".say;
    (^@nums.elems).map({ @nums @+% pattern($_ + 1) });
}

my @nums = slurp('16.txt').comb(/\d/);

@nums = FFT(@nums) for ^100;

say @nums;
say @nums[0..7].join;