use lib '.';
use intcode;

my $input = Channel.new;
my $output = Channel.new;
my $machine = IntCode.new(progtext => slurp('17.txt'), input => $input, output => $output);
my $prom = $machine.exec-async();

my @grid[;];

sub receive($x, $y) {
    my $token = $output.receive;
    if $token == 35 {
        @grid[$y][$x] = '#';
        return receive($x + 1, $y);
    } 
    if $token == 46 {
        @grid[$y][$x] = '.';
        return receive($x + 1, $y);
    }
    if $token == 94 {
        @grid[$y][$x] = '^';
        return receive($x + 1, $y);
    }
    if $token == 60 {
        @grid[$y][$x] = '<';
        return receive($x + 1, $y);
    }
    if $token == 62 {
        @grid[$y][$x] = '>';
        return receive($x + 1, $y);
    }
    if $token == 76 {
        @grid[$y][$x] = 'v';
        return receive($x + 1, $y);
    }
    if $token == 10 {
        if $x == 0 {
            return;
        }
        return receive(0, $y + 1);
    }
    $token.say;
}

receive(0, 0);

.say for @grid;

sub isintersection(@coords) {
    isinland(@coords) and ('#' eq [
        @grid[@coords[1] + 1][@coords[0] + 0], 
        @grid[@coords[1] - 1][@coords[0] + 0], 
        @grid[@coords[1] + 0][@coords[0] + 1], 
        @grid[@coords[1] + 0][@coords[0] - 1]].all)
}

sub isinland(@coords) {
    (0 < @coords[1] < @grid.elems) and (0 < @coords[0] < @grid[0].elems);
}

sub ispath(@coords) {
    '#' eq @grid[@coords[1]][@coords[0]];
}

sub alignment(@coords) {
    [*] @coords;
}

my @intersections = (^@grid[0].elems X ^@grid.elems).grep(&ispath).grep(&isintersection);
@intersections.say;
say [+] @intersections.map(&alignment);
#638 too low