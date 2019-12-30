use lib '.';
use intcode;

my @bounds;

sub check($x, $y) {
    my $input = Channel.new;
    my $output = Channel.new;
    my $machine = IntCode.new(progtext => slurp('19.txt'), input => $input, output => $output);
    $machine.exec-async();
    $input.send($_) for $x, $y;
    return $output.receive eq '1';
}

sub initial() {
    my $y = 10;
    my @row = (^20).map({ check($_, $y) }).List;
    return [$y, @row.first({ so $_ }, :k), @row.first({ so $_ } , :k, :end)];
}

sub nextrow([$y, $left, $right]) {
    my $nextleft = $left;
    my $nextright = $right;
    while !check($nextleft, $y + 1) {
        $nextleft++;
    }
    while check($nextright + 1, $y + 1) {
        $nextright++;
    }
    return [$y + 1, $nextleft, $nextright];
}

my @seq = initial(), { nextrow($_) } ... *;

sub checkspace($y) {
    my @toprow := @seq[$y - 10];
    my @bottomrow := @seq[$y - 10 + 99];
    $y.say;
    (@bottomrow[1] <= (@toprow[2] - 99)) and verify(@toprow[2] - 99, $y);
}

sub verify($x, $y) {
    check($x, $y)
    and check($x + 99, $y + 99)
    and check($x + 99, $y)
    and check($x, $y + 99);
}

my @row := @seq.first({ checkspace($_[0]) });
@row.say;
my $x = @row[2] - 99;
my $y = @row[0];
((10000 * $x) + $y).say;

verify($x, $y);


# 9361157 too high
# 9351156 too high too
# 9211139 too low
# 9231141