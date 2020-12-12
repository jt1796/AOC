my $x = 0;
my $y = 0;

my $wx = 10;
my $wy = 1;

# 99096 too low
# 101860
# 109944 too high

sub toradus($x, $y) {
    return ($y / $x).atan if $x !=~= 0; 
    return 90 * 2 * pi / 360;
}

sub torad($x, $y) {
    my $us = toradus($x, $y);
    $us += (180 * 2 * pi / 360) if $x < 0;
    return $us;
}

for open('d12.txt').lines -> $line {
    my $mag = $line.comb(/\d+/).first.Int;
    my $magasrad = $mag * 2 * pi / 360;

    my $rad = torad($wx, $wy);
    my $hyp = ($wx*$wx + $wy*$wy).sqrt;

    given $line.substr(0, 1) {
        when 'N' { $wy += $mag }
        when 'E' { $wx += $mag }
        when 'S' { $wy -= $mag }
        when 'W' { $wx -= $mag }

        when 'L' { $rad += $magasrad; $wx = $hyp * $rad.cos; $wy = $hyp * $rad.sin; }
        when 'R' { $rad -= $magasrad; $wx = $hyp * $rad.cos; $wy = $hyp * $rad.sin; }

        when 'F' { $x += $mag * $wx; $y += $mag * $wy; }
    }
}

say ($x.abs + $y.abs).round;