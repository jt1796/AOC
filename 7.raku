use lib '.';
use intcode;

my $max = 0;
my $lock = Lock.new;

sub update-max($cand) {
    $lock.protect: {
        if ($cand > $max) {
            $max = $cand;
            say "new max found: $max";
            return True;
        }
    }
}

sub compute-amp(@nums) {
    my @channels = @nums.map: { input-of([$_]) };
    @channels[0].send(0);

    my @proms = (^(@nums.elems)).map({
        IntCode.new(progtext => slurp('7.txt'), input => @channels[$_], output => @channels[($_ + 1) % *]).exec-async();
    });
    await @proms;
    update-max(@proms[* - 1].result.final-val);
}

sub solve() {
    compute-amp($_) for (5, 6, 7, 8, 9).permutations;
}

solve();