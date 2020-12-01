use lib '.';
use intcode;

my $machine = IntCode.new(progtext => slurp('5.txt'), input => input-of([1]), output => output-say());
$machine.exec();