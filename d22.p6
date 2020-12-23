my @first;
my @second;

for open('d22.txt').lines {
    @first.push(+$_) if "Player 1:" ^ff^ "";
    @second.push(+$_) if "Player 2:" ^ff *;
}

my $turn = 0;
sub game(@first, @second, $depth) {
    my %seen;
    my $round;
    while ((@first, @second).all).elems > 0 {
        my $key = (@first, " / ", @second).Str;
        if %seen{ $key } {
            return True;
        }
        $round++;
        say "Round $round Game $depth" if $round % 200 == 0;
        %seen{ $key } = True;

        my $a = @first.shift();
        my $b = @second.shift();

        my $firstwins;

        if (@first.elems >= $a && @second.elems >= $b) {
            $firstwins = game(@first[^$a].Array, @second[^$b].Array, $depth + 1);
        } else {
            $firstwins = $a > $b;
        }

        my @target := $firstwins ?? @first !! @second;
        @target.push($firstwins ?? $a !! $b);
        @target.push($firstwins ?? $b !! $a);
    }

    if $depth == 1 {
        say @first, @second;
        say [+] ((@first.Slip, @second.Slip).reverse Z* (1, 2, 3 ... *));
    }
    return @first.elems > 0;
}

say game(@first, @second, 1);

# 31557 too low
# 33735 too low