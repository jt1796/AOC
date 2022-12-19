use experimental :cached;

my @input = "d12.txt".IO.lines>>.split('-');
@input = (|@input, |@input.map: *.cache.reverse);

say @input;
sub find(%seen, $at) is cached {
    my $isBig = $at.lc ne $at;
    my %seencpy is default(0) = %seen.pairs;
    if (not $isBig) {
        %seencpy{$at}++;
    }
    if $at eq "end" {
        return 1;
    }
    if %seencpy{'start'} > 1 {
        return 0;
    }

    my @nexts = @input.grep({ .[0] eq $at }).map({ .[1] });
    my $atTwo = +%seencpy.values.grep(* == 2);
    my $overTwo = +%seencpy.values.grep(* > 2);
    [+] @nexts.grep({ $isBig ?? (True) !! ($atTwo <= 1 and $overTwo == 0 ) }).map({ find(%seencpy, $_) });
}

my %initmap is default(0);
say find(%initmap, 'start');