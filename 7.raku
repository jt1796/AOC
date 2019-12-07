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
        Promise.in(1).then({ die; });
        my Channel $last = input-of([0]);
        {
            my Channel $input = input-of([$_, $last.receive]);
            $last = Channel.new;
            IntCode.new(progtext => slurp('7.txt'), input => $input, output => $last).exec();
        } for @nums;

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