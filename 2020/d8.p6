sub create-program-from(@instructions) {
    sub process-instruction(@args) {
        my ($pc, $accum) = @args;
        my $instruction = @instructions[$pc];
        given $instruction[0] {
            when 'nop' { }
            when 'acc' { $accum += $instruction[1]; }
            when 'jmp' { $pc += $instruction[1] - 1 }
            default { die "instruction $($instruction[0]) not found" }
        }

        ($pc + 1, $accum);
    }

    lazy (0, 0), { process-instruction($_) } ...^ *[0] == @instructions;
}

sub does-term(@instructions) {
    my %seenpcs;
    my @program = create-program-from(@instructions);
    my $first = @program.first(sub filter(@state) {
        if (%seenpcs{@state[0]}:exists) {
            return True;
        }

        %seenpcs{@state[0]} = True;
        False;
    });

    if ($first) {
        return %seenpcs.keys;
    } else {
        say @program.list[* - 1];
        return True;
    }
}

#############################################################################

my @instructions = open('d8.txt').lines.map: *.words.Array;
my @candidates = does-term(@instructions).grep({ @instructions[$_][0] ~~ m/nop|jmp/ });

@candidates.map({
    my @instructions = open('d8.txt').lines.map: *.words.Array;
    my $target = @instructions[$_];
    given $target[0] {
        when 'nop' { $target[0] = 'jmp' }
        when 'jmp' { $target[0] = 'nop' }
        default { die "bad $($target[0]) line" }
    }

    True == does-term(@instructions);
});