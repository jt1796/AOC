my $rank = 'AKQT98765432J';

sub sortkey($hand) {
    typeof($hand), |$hand.comb.map({ $rank.index($_) })
}

sub typeof($hand) {
    my $vals = $hand.comb(/<-[J]>/).Bag.values.Bag;
    my $js = $hand.comb.Bag<J>;

    return 1 if $js >= 4;
    if $js eq 3 {
        return 1 if $vals{2};
        return 2
    }
    if $js eq 2 {
        return 1 if $vals{3};
        return 2 if $vals{2};
        return 4;
    }
    if $js eq 1 {
        return 1 if $vals{4};
        return 2 if $vals{3};
        return 3 if $vals{2} > 1;
        return 4 if $vals{2};
        return 6;
    }

    return 1 if $vals{5};
    return 2 if $vals{4};
    return 3 if $vals{3} and $vals{2};
    return 4 if $vals{3};
    return 5 if $vals{2} > 1;
    return 6 if $vals{2};
    return 7
}

say [+] "d7.txt".IO.lines>>.split(' ').sort({ sortkey(.[0]) }).reverse.map(*[1]) Z* (1, 2 ... *);
