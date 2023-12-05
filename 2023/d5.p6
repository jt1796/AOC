my ($seeds, @maps) = "d5.txt".IO.slurp.split("map")>>.comb(/\d+/);

sub mkmapper(@lines) {
    return sub mapper($number) {
        my $relevant = @lines.first({ .[1] <= $number < (.[1] + .[2]) });
        $number + ($relevant ?? ($relevant[0] - $relevant[1]) !! 0);
    }
}

my &composed = [∘] @maps>>.rotor(3).map({ mkmapper($_) }).reverse;

$seeds.map(&composed).min.say;