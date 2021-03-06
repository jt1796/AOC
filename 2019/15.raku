use lib '.';
use intcode;

my $input = Channel.new;
my $output = Channel.new;
my $machine = IntCode.new(progtext => slurp('15.txt'), input => $input, output => $output);
my $prom = $machine.exec-async();

my $UP = 1;
my $DOWN = 2;
my $LEFT = 3;
my $RIGHT = 4;

my @oxygen;
my %grid is default('#');

my %visited is default(False);

sub find-oxygen($x, $y, $steps) {
    return False if %visited{ item [$x, $y] };
    %visited{ item [$x, $y] } = True;
    %grid{ item [$x, $y] } = ' ';

    $input.send($UP);
    my $status = $output.receive;
    if $status == 1|2 {
        if $status == 2 {
            @oxygen = [$x, $y + 1];
            "found oxygen".say;
            $steps.say;
        }
        find-oxygen($x, $y + 1, $steps + 1);
        $input.send($DOWN);
        $output.receive;
    }

    $input.send($DOWN);
    $status = $output.receive;
    if $status == 1|2 {
        if $status == 2 {
            @oxygen = [$x, $y - 1];
            "found oxygen".say;
            $steps.say;
        }
        find-oxygen($x, $y - 1, $steps + 1);
        $input.send($UP);
        $output.receive;
    }

    $input.send($LEFT);
    $status = $output.receive;
    if $status == 1|2 {
        if $status == 2 {
            @oxygen = [$x - 1, $y];
            "found oxygen".say;
            $steps.say;
        }
        find-oxygen($x - 1, $y, $steps + 1);
        $input.send($RIGHT);
        $output.receive;
    }

    $input.send($RIGHT);
    $status = $output.receive;
    if $status == 1|2 {
        if $status == 2 {
            @oxygen = [$x + 1, $y];
            "found oxygen".say;
            $steps.say;
        }
        find-oxygen($x + 1, $y, $steps + 1);
        $input.send($LEFT);
        $output.receive;
    }
}

find-oxygen(0, 0, 0);
say @oxygen; #14, 20;
%grid{ item @oxygen } = 'O';

for (0..50) -> $y {
    for (0..50) -> $x {
        print(%grid{ item [$x - 25, $y - 25] });
    }
    "".say;
}

sub adjacent(@point) {
    ((1, 0), (0, 1), (-1, 0), (0, -1)).map({ (@point Z+ $_) });
}

say adjacent([3, 4]);

my $minutes = 0;
my @frontier = [@oxygen,];
while (@frontier.elems > 0) {
    my @adjacents = @frontier.map({ adjacent($_).Slip }).grep({ %grid{ item $_ } eq ' ' });
    %grid{ item $_ } = 'O' for @adjacents;
    @frontier = @adjacents;
    $minutes++;
}

$minutes.say;
