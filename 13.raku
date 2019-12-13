use lib '.';
use intcode;

my $output = Channel.new;
my $machine = IntCode.new(progtext => slurp('13.txt'), input => input-of([1]), output => $output);

my $blocks = 0;

sub get-instruction() {
    my $x = $output.receive;
    my $y = $output.receive;
    my $tile = $output.receive;
    $blocks++ if $tile == 2;
    say "$x $y $tile"
}

start {
    get-instruction() while True;
}

await $machine.exec-async();

say $blocks;