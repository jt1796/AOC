my @input = 0,1,4,13,15,12,16;

my %idxs;
my $last = -1;
for ^@input.elems -> $i {
    %idxs{ @input[$i] }.push($i);
    $last = @input[$i];
}

for (@input.elems ..^ 30000000) -> $i {
    my $seencnt = %idxs{ $last }.elems;

    if $seencnt == 1 {
        $last = 0;
    } else {
        $last = %idxs{ $last }[* - 1] - %idxs{ $last }[* - 2];
    }

    %idxs{ $last }.push($i);
    %idxs{ $last }.shift while %idxs{ $last }.elems > 2;
}

say $last;