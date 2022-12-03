my @input = "362981754".comb.list;
my $size = 1000000;

my @realinput = @input.Slip, (@input.elems + 1, @input.elems + 2 ... $size).Slip;
my @nodelist;

class Node {
    has $.value is rw;
    has $.next is rw;

    method gist { " | " ~ self.value ~ " -> " ~ self.next.value }
}

my $cur = Node.new();
my $first = $cur;

for @realinput {
    @nodelist[$_] = $cur;
    $cur.value = $_;
    $cur.next = Node.new();
    $cur = $cur.next;
}

$cur.value = $first.value;
$cur.next = $first.next;
@nodelist[$cur.value] = $cur;

sub printlist() {
    my $ptr = @nodelist[1];
    for ^$size {
        print $ptr.value ~ ", ";
        $ptr = $ptr.next;
    }
    say "";
}

sub destination($next) {
    my @snippedvals = ($next.value, $next.next.value, $next.next.next.value);
    my $target = $cur.value - 1;
    while (@snippedvals.grep($target) or $target == 0) {
        $target = ($target - 1) % ($size + 1)
    };

    @nodelist[$target];
}

my $move = 0;
for ^(10000000) {
    $move++;
    say $move if $move % 10000 == 0;
    # scalp out three
    my $next = $cur.next;
    $cur.next = $next.next.next.next;

    # put three back
    my $tloc = destination($next);
    $next.next.next.next = $tloc.next;
    $tloc.next = $next;

    # inch forward
    $cur = $cur.next;
}

say @nodelist[1].next.value;
say @nodelist[1].next.next.value;
say @nodelist[1].next.value * @nodelist[1].next.next.value;