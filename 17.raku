use lib '.';
use intcode;

my $input = Channel.new;
my $output = Channel.new;
my $machine = IntCode.new(progtext => slurp('17.txt'), input => $input, output => $output);
my $prom = $machine.exec-async();

my @grid;

sub receive($x, $y) {
    my $token = $output.receive.chr;
    if $token eq "\n" {
        if $x == 0 {
            return;
        }
        return receive(0, $y + 1);
    }
    @grid[$y][$x] = $token;
    return receive($x + 1, $y);
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
    (0 < @coords[1] < @grid.elems - 1) and (0 < @coords[0] < @grid[0].elems - 1);
}

sub ispath(@coords) {
    '#' eq @grid[@coords[1]][@coords[0]];
}

sub alignment(@coords) {
    [*] @coords;
}

say @grid[0].elems;

my @intersections = (^@grid[0].elems X ^@grid.elems)
        .grep(&ispath)
        .grep(&isintersection);
@intersections.say;
say [+] @intersections.map(&alignment);
