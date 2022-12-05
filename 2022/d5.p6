my @stacks = $_>>.grep(/\w/).grep(*.elems)>>.Array with [Z] open('d5.txt').lines.grep(/\[/)>>.comb;
my @insts = open('d5.txt').lines.grep(/move/)>>.comb(/\d+/);

@stacks[.[2] - 1].splice(0, 0, @stacks[.[1] - 1].splice(0, +.[0])) for @insts;
say @stacks>>.first.join;
