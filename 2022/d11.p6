my @monkeys = open("d11.txt").split(/\n\n/).map({
    my %monkey;

    for .lines {
        given $_ {
            when /Starting/ { %monkey<items> = .comb(/\d+/).Array }
            when /Operation\:\snew\s\=\s(.*)\s(.)\s(.*)/ { %monkey<op> = $/[0,1,2] }
            when /Test/ { %monkey<test> = .comb(/\d+/)[0] }
            when /If\strue/ { %monkey<true> = .comb(/\d+/)[0] }
            when /If\sfalse/ { %monkey<false> = .comb(/\d+/)[0] }
        }
    }

    %monkey;
});

my $bignum = [lcm] @monkeys>>.<test>;

for ^10000 {
    for @monkeys {
        my @op = .<op>.map(*.Str);
        my &op = (&[+], &[*])[@op[1] eq "*"];
        my @items = .<items>.map({ [[&op]] @op[0,2]>>.subst("old", $_) }).map( * % $bignum ); 
        .<items> = [];
        .<count> += @items;

        for @items -> $item {
            my $to = (.<false>, .<true>)[$item %% .<test>];
            @monkeys[$to].<items>.push($item);
        }
    }
}

say [*] @monkeys>>.<count>.sort.reverse[0,1];
