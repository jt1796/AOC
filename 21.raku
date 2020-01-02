use lib '.';
use intcode;

my $input = Channel.new;
my $output = Channel.new;
my $machine = IntCode.new(progtext => slurp('21.txt'), input => $input, output => $output);
my $prom = $machine.exec-async();

sub get-word() {
    my $msg = "";
    my $next;
    ($msg = $msg ~ $output.receive.chr) while !$msg.ends-with("\n");
    return $msg;
}

my $instructions = qq:to/END/;
    NOT A J
    NOT B T
    OR T J
    NOT C T
    OR T J
    AND D J
    END

get-word().say; # Input instructions: 
$input.send($_) for $instructions.ords;
$input.send($_) for "WALK\n".ords;
get-word().say;
get-word().say;
get-word().say;
$output.receive.say for ^Inf;