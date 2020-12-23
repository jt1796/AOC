my @input = "362981754".comb.list;

my $len = @input.elems;

for ^100 {
    my $cup = @input[0];
    @input = @input.rotate;
    my @takes = (@input.shift, @input.shift, @input.shift);
    my $target = $cup - 1;
    while (@takes.grep($target) or $target == 0) {
        $target = ($target - 1) % ($len + 1)
    };
    while @input.head ne $target {
        @input = @input.rotate
    };
    @input.splice(1, 0, @takes);
    while @input.head ne $cup { @input = @input.rotate }
    @input = @input.rotate;
}

(@input = @input.rotate) until @input[0] == 1;

say @input.grep(none 1).join('');