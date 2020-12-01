use lib '.';
use intcode;

my @natinst = [-Inf, -Inf];

my @inputs = (^50).map: { Channel.new };
my @machines = (^50).map: -> $addr {
    my $machineoutput = Channel.new;
    $machineoutput.Supply.rotor(3).tap({ process-output(|$_) });
    @inputs[$addr].send($addr);
    my $machine = IntCode.new(progtext => slurp('23.txt'), readblock => False, input => @inputs[$addr], output => $machineoutput);
}

sub process-output($addr, $x, $y) {
    # [$addr, $x, $y].say;
    if 255 == $addr {
        @natinst = [$x, $y];
    } else {
        @inputs[$addr].send($_) for $x, $y;
    }
}


start {
    my $lasty = Inf;
    Supply.interval(5).tap({
        "NAT waking up".say;
        my $idle = so @machines.all.is-idle();
        say $idle;
        if $idle {
            "transmitting $@natinst".say;
            @inputs[0].send($_) for @natinst;
            if $lasty == @natinst[1] {
                "ANSWER $lasty".say;
                $lasty.say;
                die;
            }
            $lasty = @natinst[1];
        };
    });
}


await Promise.allof(@machines.map: *.exec-async());
