my @input = open('d17.txt').lines.map: *.comb.map({ $_ eq "#" }).list;

my %space is default(False);

for @input.keys -> $r {
    for @input[$r].keys -> $c {
        if (@input[$r][$c]) {
            %space{ [$r, $c, 0, 0].Str } = True;
        }
    }
}

sub neighbors($loc) {
    my @coords = $loc.split(" ").map(+*);
    ([X] (-1, 0, 1) xx 4).grep({ ! ($_.all == 0) }).map({ $_ >>+<< @coords });
}

sub age(%space) {
    my %counts is default(0);
    for %space.keys -> $key {
        for neighbors($key) -> @loc {
            %counts{ @loc.Str }++;
        }
    }

    my %newspace is default(False);

    for %space.keys -> $key {
        my $n = %counts{ $key };
        if ($n == 2|3) {
            %newspace{ $key } = True;
        }
    }

    for %counts.keys -> $key {
        my $active = %space{ $key };
        my $n = %counts{ $key };
        if (!$active && $n == 3) {
            %newspace{ $key } = True;
        }
    }

    %newspace;
}

my @evolution = %space, { age($_) } ... *;

say @evolution[^7].map: *.elems;