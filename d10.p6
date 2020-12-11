my @jolts = open('d10.txt').words.map(*.Numeric).sort;

sub solve(@jolts) {
    my $start = @jolts.min - 1;
    my $target = @jolts.max;

    sub count-perms(@jolts, $curvolts) {
        return 1 if $curvolts >= $target;
        my @candidates = @jolts.grep($curvolts < * <= $curvolts + 3);
        return 0 if @candidates.elems == 0;
        return [+] @candidates.map({
            count-perms(@jolts.grep(* != $_), $_);
        });
    }

    return count-perms(@jolts, $start);
}

my @breakpoints = -1, @jolts.keys.skip.grep({ @jolts[$_] >= 3 + @jolts[$_ - 1] }).Slip, @jolts.end;
my @divided = (@breakpoints Z @breakpoints.rotate(1)).map: { @jolts[$_[0]^..$_[1]] };

say [*] (@divided).map: { solve($_) };