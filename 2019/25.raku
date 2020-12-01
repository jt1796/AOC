use lib '.';
use intcode;

my $input = Channel.new;
my $output = Channel.new;
my $machine = IntCode.new(progtext => slurp('25.txt'), input => $input, output => $output);
my $prom = $machine.exec-async();

sub get-word() {
    my $msg = "";
    my $next;
    ($msg = $msg ~ $output.receive.chr) while !$msg.ends-with("\n");
    if (m/Command/ with $msg) {
        $input.send($_) for prompt("Enter Command: ").ords;
        $input.send(10);
    }
    return $msg;
}

while True {
    get-word().say;
}
