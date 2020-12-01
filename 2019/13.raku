use lib '.';
use intcode;

my $output = Channel.new;
my $input = Channel.new;
my $machine = IntCode.new(progtext => slurp('13.txt'), input => $input, output => $output);

my @grid[;];
my $score = 0;
my $bally = 0;
my $pady = 0;

sub say-grid() {
    return if @grid[0].elems < 20;
    say "\n" x 20;
    "======= SCORE $score =======".say;
    .say for @grid;
}

sub get-instruction() {
    my $x = $output.receive;
    my $y = $output.receive;
    my $tile = $output.receive;
    if ($x == -1 and $y == 0) {
        $score = $tile;
    } else {
        my $char = (' ', 'W', 'B', '|', 'O')[$tile];
        $bally = $x if $char eq 'O';
        $pady = $x if $char eq '|';
        @grid[$x][$y] = $char;
    }
}

start {
    Supply.interval(1).tap({
        say-grid();
    });
}

start {
    get-instruction() while True;
}

start {
    sleep(5);
    Supply.interval(0.25).tap({
        $input.send(($bally - $pady).sign);
    });
}

await $machine.exec-async();
say-grid();