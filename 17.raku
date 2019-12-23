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

# .say for [Z] @grid;

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

my @intersections = (^@grid[0].elems X ^@grid.elems)
        .grep(&ispath)
        .grep(&isintersection);
@intersections.say;
say [+] @intersections.map(&alignment);
##
# part 2
##


my @coords = (^@grid[0].elems X ^@grid.elems).first({ ('<', '>', 'v', '^').any eq @grid[$_[1]][$_[0]] });
@coords.say;
sub mutate-build-path($x is rw, $y is rw) {
    my $nextangle = Nil;
    $nextangle = 270 if @grid[$y + 1][$x] eq '#';
    $nextangle = 0 if @grid[$y][$x + 1] eq '#';
    $nextangle = 90 if $y > 0 and @grid[$y - 1][$x] eq '#';
    $nextangle = 180 if $x > 0 and @grid[$y][$x - 1] eq '#';
    return unless $nextangle.defined;
    my $angle = {'^' => 90, 'v' => 270, '>' => 0, '<' => 180}{ @grid[$y][$x] };
    my $diff = ($nextangle - $angle + 360) % 360;
    if $diff == 0 {
        my @updater = { 0 => (1, 0), 270 => (0, 1), 180 => (-1, 0), 90 => (0, -1) }{ $angle }.flat;
        (my $nextx, my $nexty) = (($x, $y) Z+ @updater);
        my $ctr = 0;
        while $nexty >= 0 and $nextx >= 0 and ('#', '+').any eq @grid[$nexty][$nextx] {
            @grid[$nexty][$nextx] = @grid[$y][$x];
            @grid[$y][$x] = '+';
            ($x, $y) = ($nextx, $nexty);
            ($nextx, $nexty) = (($nextx, $nexty) Z+ @updater);
            $ctr++;
        }
        return $ctr, mutate-build-path($x, $y).Slip;
    } else {
        my @rotate = ('<', '^', '>', 'v');
        my $idx = @rotate.first(@grid[$y][$x], :k) + ($diff == 90 ?? -1 !! 1);
        @grid[$y][$x] = @rotate[$idx % *];
        return ({90 => 'L', 270 => 'R'}{ $diff }), mutate-build-path($x, $y).Slip;
    }
}

my @path = mutate-build-path(|@coords).grep: { .defined };

sub compress(@used, $start) {
    return [True] if $start == @path.elems;
    for ($start + 1)..min(@path.elems - 1, $start + 10) -> $next {
        if @used.first( ~@path[$start..$next], :k).defined {
            my @child = compress(@used, $next + 1);
            if @child {
                return @path[$start..$next], |@child;
            }
        } elsif @used.elems < 3 {
            my @nextused = @used.clone;
            @nextused.push( ~@path[$start..$next]);
            my @child = compress(@nextused, $next + 1);
            if @child {
                return @path[$start..$next], |@child;
            }
        }
    }
    return [];
}

my @compressed = compress([].clone, 0).grep({ $_ !eq [True] });
say @path;
say @compressed;
my %fns;
my @fnnames = ("A", "B", "C");
%fns = @compressed.unique(with => &[eq]).map({ item $_ => @fnnames.shift });
my @main = @compressed.map({ %fns{ $_ } }).join(',').Str.ords;
my @routines = @compressed.unique(with => &[eq]).sort( { %fns{ item $_ } } ).map({ .join(',').Str.ords });
say @main;
say @routines;

sub get-word() {
    my $msg = "";
    my $next;
    ($msg = $msg ~ $output.receive.chr) while !$msg.ends-with("\n");
    return $msg;
}

say get-word();
$input.send($_) for @main;
$input.send("10");
for @routines -> @routine {
    say get-word();
    $input.send($_) for @routine;
    $input.send("10");
}
say get-word();
$input.send("n".ords);
$input.send("10");
$output.receive.say for ^10000;



#46 not right