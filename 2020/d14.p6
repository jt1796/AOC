my %mem;
my $mask = "";

sub mask($mask, $val) {
    my @maskfmt = $mask.comb.reverse;
    my @valfmt = (0 + $val).base(2).comb.reverse.Slip, (0, 0 ... *)[^36].Slip;
    my @actl = zip(@maskfmt, @valfmt).map(-> [$m, $v] {
        given $m {
            when 'X' { 'X' }
            when '0' { $v }
            when '1' { 1 }
        }
    });

    my @bitstr = @actl[^36].reverse;

    my @floatingidxs = @bitstr.grep({ $_ eq 'X' }, :k);
    return @floatingidxs.combinations.map({
        my @copy = @bitstr;
        for $_ -> $idx { @copy[$idx] = 1 };
        S:g/X/0/ with @copy.join('');
    });
}

for open('d14.txt').lines -> $line {
    if $line ~~ /mask/ {
        $mask = $line.split(" = ")[1];
    } else {
        my $val = 0 + $line.split(" = ")[1];
        my $loc = $/[0].Str with $line ~~ /\[(\d+)\]/;

        my @mems = mask($mask, $loc);
        for @mems -> $mem {
            %mem{ $mem } = $val;
        }
    }
}

say %mem.values.sum;