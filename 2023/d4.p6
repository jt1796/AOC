my @input = "d4.txt".IO.lines.map({S/Card.*\://})>>.split("|")>>.comb(/\d+/)>>.map(*.Set);

my @scores = @input.map({ [∩] $_ }).map(*.elems);
my $counts = @scores.map({ 1 }).Array;

for @scores.kv -> $i, $v {
    $counts[$_] += $counts[$i] for $i ^.. $v+$i;
}

say $counts.sum;
