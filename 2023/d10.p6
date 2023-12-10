use PriorityQueue;
my $pq = PriorityQueue.new(:cmp(*[0]));

my @input = "d10.txt".IO.lines>>.comb>>.Array.Array;

sub findS() {
    (0, .[0], .[1].first("S", :k)) with @input.first("S" (elem) *, :kv);
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
     # 'S' => %dirs<U R>,
};

$pq.push(findS());

@input>>.join>>.say;

my %seen;
while $pq.shift -> ($d, $r, $c) {
    my $sym = @input[$r][$c] || ".";
    next if $sym eq '.' or %seen{$r ~ '_' ~ $c}:exists;
    %seen{$r ~ '_' ~ $c} = $d;

    $pq.push(($d + 1, .[0], .[1])) for (($r, $c), *) <<«+»>> %mmap{$sym};
}

say %seen.values.max;

# 6848 too low

# DFS to do the full loop and wind back up at S