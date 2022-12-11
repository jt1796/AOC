my @monkeys = open("d11.txt").split(/\n\n/).map({
    .hash with .lines.map: {
        given $_ {
            when /Starting/ { 'items' => .comb(/\d+/).Array }
            when /Operation\:\snew\s\=\s(.*)\s(.)\s(.*)/ { 'op' => $/[0,1,2] }
            when /Test/ { 'test' => .comb(/\d+/)[0] }
            when /If\strue/ { 'true' => .comb(/\d+/)[0] }
            when /If\sfalse/ { 'false' => .comb(/\d+/)[0] }
            default { '' => '' }
        }
    }
});

my $bignum = [lcm] @monkeys>>.<test>;

for ^10000 {
    for @monkeys {
        my @op = .<op>.map(*.Str);
        my &op = (&[+], &[*])[@op[1] eq "*"];
        my @items = .<items>.splice(0, *).map({ [[&op]] @op[0,2]>>.subst("old", $_) }).map(* % $bignum); 
        .<count> += @items;

        for @items -> $item {
            my $to = (.<false>, .<true>)[$item %% .<test>];
            @monkeys[$to].<items>.push($item);
        }
    }
}

say [*] @monkeys>>.<count>.sort.reverse[0,1];
