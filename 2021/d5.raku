my $bag = [⊎] "d5.txt".IO.lines
    .map(*.comb(/\d+/).map(*.Int))
    .map({ .map(*.join('_')).Bag with (.[0] ... .[2]) <<,>> (.[1] ... .[3]) });

say $bag.values.grep(* > 1).elems;