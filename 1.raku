sub fuel(Int $weight) {
    ($weight / 3 - 2).floor
}

sub weights($initial) {
    fuel($initial), { fuel($^a) } ...^ * <= 0
}

say [+] (slurp '1.txt' ==> comb /<digit>+/ ==> map { weights(+$^a) } ==> flat)