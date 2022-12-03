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

my $round = 0.001;

sub neighbors($img) {
    return (^6).map({ $img + 1.unpolar($_ * pi / 3) }).map(*.round($round));
}

sub nextday($blacks) {
    my %hitcounter is default(0) = $blacks.keys.map({ neighbors($_).Slip }).Bag;
    my $newblacks = $blacks.SetHash;

    for $blacks.keys -> $k { 
        if %hitcounter{ $k } == 0 or %hitcounter{ $k } > 2 {
            $newblacks.unset($k);
        }
    }

    for %hitcounter -> $kv {
        if $kv.key ∉ $blacks and $kv.value == 2 {
            $newblacks.set($kv.key);
        }
    }

    return $newblacks.Set;
}

my $start = @ends.map({ .round($round) }).Bag.grep({ .value % 2 == 1 }).map(*.key.Str).Set;
my @seq = ($start, { nextday($_) } ... *).map: *.elems;

say @seq[^101].raku;