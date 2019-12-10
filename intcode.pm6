unit module AOCUtils;

class IntCode is export {
    has Str $.progtext is required;
    has Channel $.input is required;
    has Channel $.output is required;
    has $.final-val is rw;
    has Int $.relative-base is rw = 0;

    method get-param($at, $mode, @tape) {
        my $raw = @tape[$at];
        return @tape[$raw] if $mode == 0;
        return $raw if $mode == 1;
        return @tape[$raw + self.relative-base] if $mode == 2;
    }

    method tick(@tape, Int $pc --> Int) {
        my @instruction = ('00000' ~ @tape[$pc]).split('');
        my $opcode = +@instruction[*-2..*].join();
        my @modes = @instruction[*-7..*-4].reverse;

        sub param(Int $pos) {
            self.get-param($pc + 1 + $pos, @modes[$pos], @tape);
        }

        sub immdt(Int $pos) {
            my $offset = 0;
            $offset = self.relative-base if @modes[$pos] == 2;
            $offset + self.get-param($pc + 1 + $pos, 1, @tape);
        }

        if $opcode == 1 {
            @tape[immdt(2)] = param(0) + param(1);
            return 4;
        }

        if $opcode == 2 {
            @tape[immdt(2)] = param(0) * param(1);
            return 4;
        }

        if $opcode == 3 {
            @tape[immdt(0)] = self.input.receive;
            return 2;
        }

        if $opcode == 4 {
            $.final-val = param(0);
            $.output.send(param(0));
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

        if $opcode == 9 {
            self.relative-base += param(0);
            return 2;
        }

        die;
    }

    method exec-async() {
        start {
            self.exec();
            self;
        }
    }

    method exec() {
        my @tape is default(0) = $!progtext.comb(/"-"?<digit>+/);
        my $pc = 0;
        $pc += self.tick(@tape, $pc) while (@tape[$pc] != 99);
    }
}

sub input-of(@vals) is export {
    my $channel = Channel.new;
    $channel.send($_) for @vals;
    $channel;
}

sub output-say() is export {
    my $channel = Channel.new;
    start {
        channel-say($channel);
    }

    return $channel;
}

sub channel-say(Channel $chan) {
    $chan.receive.say;
    channel-say($chan);
}