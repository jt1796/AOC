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

=begin comment
    OR I T
    AND I T
    AND E T
    OR H T
    AND T J

    OR A T
    AND A T
    OR B T
    OR C T
    NOT T T
    OR T J
=end comment




my $instructions = qq:to/END/;
    NOT A J
    NOT B T
    OR T J
    NOT C T
    OR T J
    AND D J
    OR I T
    AND I T
    AND E T
    OR H T
    AND T J
    NOT A T
    OR T J
    END

get-word().say; # Input instructions: 
$input.send($_) for $instructions.ords;
$input.send($_) for "RUN\n".ords;
$output.receive.say for ^Inf;
get-word().say for ^Inf;