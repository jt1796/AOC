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
    return start {
        my Channel $last = input-of([0]);

        await @nums.map({
            my Channel $input = input-of([$_, $last.receive]);
            $last = Channel.new;
            IntCode.new(progtext => slurp('7.txt'), input => $input, output => $last).exec-async();
        });

        my $val = $last.receive;

        if (update-max($val)) {
            @nums.say;
        }
    }
}


# perms
sub solve() {
    {
        await Promise.allof($_.map: { compute-amp($_) });
    } for ((0, 1, 2, 3, 4).permutations).batch(10);
}

solve();