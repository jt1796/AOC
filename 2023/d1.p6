my @digits = <zero one two three four five six seven eight nine>;
my @literals = <0 1 2 3 4 5 6 7 8 9>;

say "d1.txt".IO.lines.map(-> $line {
    sub pairs(@list) { |.flat.rotor(2) with @list.map({ $line.indices($_) }) >>,>> ^Inf };

    pairs(@digits), pairs(@literals);
}).map({ .sort(*.[0]) }).map({ .[0][1] ~ .[*-1][1] }).sum;
