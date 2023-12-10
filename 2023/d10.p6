use PriorityQueue;
my $pq = PriorityQueue.new(:cmp(*[0]));

my @input = "d10.txt".IO.lines>>.comb>>.Array.Array;

sub findS() {
    (.[0], .[1].first("S", :k)) with @input.first("S" (elem) *, :kv);
}

my %dirs := { U => (-1, 0), D => (1, 0), L => (0, -1), R => (0, 1) };
my %mmap := {
    '|' => %dirs<U D>,
    '-' => %dirs<L R>,
    'L' => %dirs<U R>,
    'J' => %dirs<U L>,
    '7' => %dirs<L D>,
    'F' => %dirs<R D>,
    '.' => (),
    'S' => %dirs<U D L R>,
     #'S' => %dirs<U R>,
};

$pq.push(findS());

@input>>.join>>.say;

my %seen;
sub findLoop($dist, $r, $c) {
    my $sym = @input[$r][$c] || '.';
    return -1 if $sym eq '.';
    return $dist if $sym eq 'S' and $dist > 0;
    return -1 if %seen{ $r ~ '_' ~ $c }:exists;

    %seen{ $r ~ '_' ~ $c } = True;
    my $max = .map({ findLoop($dist + 1, .[0], .[1]) }).max with (($r, $c), *) <<«+»>> %mmap{$sym};
    %seen{ $r ~ '_' ~ $c } = False;

    return $max;
}

say findLoop(0, |findS());
