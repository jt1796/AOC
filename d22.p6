my @first;
my @second;

for open('d22.txt').lines {
    @first.push(+$_) if "Player 1:" ^ff^ "";
    @second.push(+$_) if "Player 2:" ^ff *;
}

my $turn = 0;
while ((@first, @second).all).elems > 0 {
    my $a = @first.shift();
    my $b = @second.shift();
    my @target := $a > $b ?? @first !! @second;
    @target.push(($a, $b).max, ($a, $b).min);

    $turn++;
}

say $turn;

my @winner := (@first, @second).max;
say @winner;
my @scoreseq = (1, 2, 3 ... *);
say [+] @winner.reverse Z* @scoreseq;