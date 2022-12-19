my @picks;
my @boards;
my %picked;

for "d4.txt".IO.lines {
    FIRST { @picks = $_.comb(/\d+/) }
    @boards[*-1].push($_.comb(/\d+/).Array) if m/\d+<space>\d+/;
    @boards.push([]) if $_ eq '';
}

say @picks.map(-> $pick {
    my &losers = sub () {
        @boards.grep({ not so %picked{(($_, [Z] .list).any).any.all}});
    }
    my @prepick = &losers();
    %picked{$pick} = True;
    @prepick.elems > 0 && &losers().elems == 0
        && ($pick * [+] .grep({ not %picked{$_} }) with gather @prepick[0]>>.take);
}).first(so *);
