my @input = open('d17.txt').comb.cache;
my @inst = (@input xx *).flat;
my $inst = 0;
my @tape = |('#' xx 7),  |('.' xx *);
my $top = 1;

my @shapes = (|(
    (0,1,2,3).map(* + 2),
    (1,7,8,9,15).map(* + 2),
    (0,1,2,9,16).map(* + 2),
    (0,7,14,21).map(* + 2),
    (0,1,7,8).map(* + 2),
) xx *).flat;

sub print() { .say for @tape.rotor(7)[^20].reverse; }

my $seq = @shapes.map({
    $_ = .map(* + 21 + $top * 7).List;
    my $done = False;
    while !$done {
        if @inst[$inst++] eq '>' {
            unless .map(* + 1).any %% 7 or (@tape[|$_.map(* + 1)].any eq '#') {
                $_ = .map(* + 1).List;
            }
        } else {
            unless .any %% 7 or (@tape[|$_.map(* - 1)].any eq '#') {
                $_ = .map(* - 1).List;
            }
        }
        if (@tape[|$_.map(* - 7)].all eq '.') {
            $_ = .map(* - 7).List;
        } else {
            $done = True;
            $top = max($top, 1 + (.max / 7).Int);
        }
    }

    @tape[|$_] = '#' xx *;
    # print();
    $top - 1;
});

my @diffs = ($seq.cache.skip Z- $seq.cache);
my @fingerprint = @diffs[^10 + 100];
my @bounds;
for ^5000 {
    if @fingerprint eq @diffs[^10 + $_] {
        @bounds.push: $_;
    }
}
my $period = @bounds[1] - @bounds[0];
my $periodchange = @diffs[@bounds[0]...^@bounds[1]].sum;


my $first = @bounds[0];
my $second = $period * floor((1000000000000 - $first) / $period);
my $last = 1000000000000 - $first - $second;

my $ans = @diffs[^$first].sum + ($second / $period * $periodchange) + @diffs[^$last + @bounds[1]].sum;
say $ans;
