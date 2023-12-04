my @input = "d4.txt".IO.lines.map({S/Card.*\://})>>.split("|")>>.comb(/\d+/)>>.map(*.Set);

my @scores = 0, 1, 2, 4 ... *;

say @input.map({ [∩] $_ }).map({ @scores[$_] }).sum;
