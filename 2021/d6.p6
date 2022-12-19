use experimental :cached;

sub findSoln($seed, $rem) is cached {
    return 1 if $rem == 0;

    my @nums = ($seed,).map: * - 1;
    @nums = (|@nums, |(8 xx @nums.grep(* eq -1).elems));
    @nums = @nums.map({ $_ eq -1 ?? 6 !! $_ });

    return [+] @nums.map({ findSoln($_, $rem - 1) });
}

say [+] "d6.txt".IO.lines.comb(/\d+/).map({ findSoln($_, 256) });
