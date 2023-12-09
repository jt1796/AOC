sub calcline(@line) {
    return 0 if @line.all eq 0;

    return @line[0] - calcline(@line.skip Z- @line);
}

say "d9.txt".IO.lines>>.words.map({ calcline($_) }).sum;
