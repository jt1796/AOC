sub get-param($at, $mode, @tape) {
    my $raw = @tape[$at];
    return @tape[$raw] if $mode == 0;
    return $raw if $mode == 1;
}

sub tick(@tape, Int $pc --> Int) {
    my @instruction = ('00000' ~ @tape[$pc]).split('');
    my $opcode = +@instruction[*-2..*].join();
    my @modes = @instruction[*-7..*-4].reverse;

    sub param(Int $pos) {
        return get-param($pc + 1 + $pos, @modes[$pos], @tape);
    }

    sub immdt(Int $pos) {
        return get-param($pc + 1 + $pos, 1, @tape);
    }

    if $opcode == 1 {
        my $sum = param(0) + param(1);
        @tape[immdt(2)] = $sum;
        return 4;
    }

    if $opcode == 2 {
        my $sum = param(0) * param(1);
        @tape[immdt(2)] = $sum;
        return 4;
    }

    if $opcode == 3 {
        my $input = prompt "INPUT: ";
        @tape[immdt(0)] = $input;
        return 2;
    }

    if $opcode == 4 {
        say "PRINT: " ~ @tape[immdt(0)];
        return 2;
    }

    if $opcode == 5 {
        return (param(1) - $pc) if +param(0) != 0;
        return 3;
    }

    if $opcode == 6 {
        return (param(1) - $pc) if +param(0) == 0;
        return 3;
    }

    if $opcode == 7 {
        if +param(0) < +param(1) {
            @tape[immdt(2)] = 1;
        } else {
            @tape[immdt(2)] = 0;
        }
        return 4;
    }

    if $opcode == 8 {
        if +param(0) == +param(1) {
            @tape[immdt(2)] = 1;
        } else {
            @tape[immdt(2)] = 0;
        }
        return 4;
    }

    die;
}

@tape = slurp('5.txt').comb(/"-"?<digit>+/);
my $pc = 0;
($pc += tick(@tape, $pc)) while (@tape[$pc] != 99);