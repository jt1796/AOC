my %digitmap = 0 => <a b c e f g>,
    1 => <c f>,
    2 => <a c d e g>,
    3 => <a c d f g>,
    4 => <b c d f>,
    5 => <a b d f g>,
    6 => <a b d e f g>,
    7 => <a c f>,
    8 => <a b c d e f g>,
    9 => <a b c d f g>;

my %sizemap = 2 => <1>,
                3 => <7>,
                4 => <4>,
                5 => <2 3 5>,
                6 => <0 6 9>,
                7 => <8>;

sub validity(@sets) {
    return True if @sets.elems == 0;
    return False if @sets.any().elems == 0;
    return so @sets[0].first(-> $let { validity(@sets[1..*].map({ $_ (-) $let })) });
}

sub decode($str) {
    my @words = $str.comb(/\w+/).map: *.comb.sort.join;
    my @letters = <a b c d e f g>;

    my @uniq = @words.unique;
    for [X] @uniq <<,>> @uniq.map({ %sizemap{.chars}.list }) -> @tuples {
        my %possibles;
        %possibles{$_} = @letters for @letters;
        for @tuples -> @pair {
            for @pair[0].comb -> $let {
                %possibles{$let} ∩= %digitmap{@pair[1]};
            }
        }

        if validity(%possibles.values) {
            my %map = @tuples.flat;
            return @words.map({ %map{$_} }).reverse()[^4].reverse().join;
        }
    }
}

say [+] "d8.txt".IO.lines>>.&decode;
