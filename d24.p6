my @ends = open('d24.txt').lines.map: {
    travel(0 + 0i, $_);
}

sub travel($img, $dxns) {
    return $img unless $dxns;
    given $dxns {
        when /^ne/ { travel($img + 1.unpolar(1 * pi / 3), $dxns.substr(2)) }
        when /^nw/ { travel($img + 1.unpolar(2 * pi / 3), $dxns.substr(2)) }
        when /^se/ { travel($img + 1.unpolar(5 * pi / 3), $dxns.substr(2)) }
        when /^sw/ { travel($img + 1.unpolar(4 * pi / 3), $dxns.substr(2)) }
        when /^e/  { travel($img + 1.unpolar(0 * pi / 3), $dxns.substr(1)) }
        when /^w/  { travel($img + 1.unpolar(3 * pi / 3), $dxns.substr(1)) }
        default { die; }
    }
}

say @ends.map({ .round(0.0001) }).Bag.grep({ .value % 2 == 1 }).elems;