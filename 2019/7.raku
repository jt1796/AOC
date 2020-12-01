use lib '.';
use intcode;

sub compute-amp(@nums) {
    my @channels = @nums.map: { input-of([$_]) };
    @channels[0].send(0);

    my @proms = (^(@nums.elems)).map({
        IntCode.new(progtext => slurp('7.txt'), input => @channels[$_], output => @channels[($_ + 1) % *]).exec-async();
    });

    await @proms;
    @proms[* - 1].result.final-val;
}

(5, 6, 7, 8, 9).permutations.map({ compute-amp($_) }).max().say;