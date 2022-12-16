my @input = open('d15.txt').lines>>.comb(/\-?\d+/)>>.Num;
my @diffs = @input.map({ .[0], .[1], (.[2] - .[0]).abs + (.[3] - .[1]).abs });

sub solve($line, $bmin, $bmax) {
    sub pow(&f, $i) { $i, { &f($_) } ... *.Str eq *.Str };

    sub combine(@intervals) {
        my @ver = @intervals.grep({ .[0] < .[1] });
        return @ver if @ver.elems < 2;
        my @explode = @ver.combinations(2).map({ (.[0][0] - 1 <= .[1][0|1] <= .[0][1] + 1) ?? (.[*;*].min, .[*;*].max) !! |$_ }).unique(:with(&[eq]));
        @explode.grep(-> @outer { ! @explode.grep(-> @inner { @outer.Str ne @inner.Str and @inner[0] <= @outer[0] <= @outer[1] <= @inner[1] }) });
    }
    my @ranges = @diffs.map({ my $m = .[0]; my $d = .[2] - (.[1] - $line).abs; (($m - $d),($m + $d)) });
    @ranges = @ranges.map({ max($bmin, .[0]), min($bmax, .[1]) });
    my @final = pow(&combine, @ranges)[* - 1];
    say @final if @final.elems > 1;
    say $line if @final.elems > 1;
    say $line if $line %% 10000;
}

solve($_, 0, 4000000) for 0...4000000;
