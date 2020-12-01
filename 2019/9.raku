use lib '.';
use intcode;

my $machine = IntCode.new(progtext => slurp('9.txt'), input => input-of([2]), output => output-say());
$machine.exec();