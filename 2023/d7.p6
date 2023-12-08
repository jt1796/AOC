my $rank = 'AKQJT98765432';

sub sortkey($hand) {
    typeof($hand), |$hand.comb.map({ $rank.index($_) })
}

sub typeof($hand) {
    # /<-[J]>/
    my $vals = $hand.comb().Bag.values.Bag;
    my $js = $hand.comb.Bag<J>;

    # my $jxn = (0 .. $js).any;
    # my $jxnTwo = (0 .. $js).map({ ((0 ... $_) Z, ($_ ... 0)) }).map(*.Slip).any;

    return 1 if $vals{5} > 0;
    return 2 if $vals{4} > 0;
    return 3 if $vals{3} > 0 and $vals{2} > 0;
    return 4 if $vals{3} > 0;
    return 5 if $vals{2} > 1;
    return 6 if $vals{2} > 0;
    return 7
}

# BUG
say typeof("1234J");

say [+] "d7.txt".IO.lines>>.split(' ').sort({ sortkey(.[0]) }).reverse.map(*[1]) Z* (1, 2 ... *);

# 251266689 too high
