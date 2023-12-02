say [+] "d2.txt".IO.lines.map({
    m:s/Game (\d+)\: (.*)/;
    my $hand = $1.split("; ")>>.split(", ")>>.split(" ")>>.map(*.Hash.invert).map({ .Hash with [(+)] $_ });
    sub combine { $^a >>max<< $^b };
    [*] .values with  [[&combine]] $hand;
});
