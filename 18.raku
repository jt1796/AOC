my @input = slurp('18.txt').lines.map({ $_.comb.List }).List;
my ($startx, $starty) = key-location-of('@');
my $keys = @input.List.flat.grep( { m:g/<lower>/ } ).elems;
my @keytexts = @input.List.flat.grep( { m:g/<lower>/ } );

sub key-location-of($key) {
    my $starty = @input.first({ $_.contains($key) }, :k);
    my $startx = @input[$starty].first($key, :k);
    return ($startx, $starty);
}

sub gen-key-dist() {
    my %keylocations = @keytexts.List.flat.grep( { m:g/<lower>/ } ).map({ $_ => key-location-of($_) });
    my %distmap;

    for @keytexts -> $key {
        my @frontier = ((%keylocations{ $key }.Slip, 0),);
        my %seen is default(False);

        while @frontier.elems > 0 {
            my $next = @frontier.shift;
            my $expand = $next[0..1];
            my $steps = $next[2];
            my $marker = @input[$expand[1]][$expand[0]];

            next if $marker eq '#';
            next if %seen{ item $expand };
            %seen{ item $expand } = True;

            @frontier.push([$_.Slip, $steps + 1]) for adjacents($expand);
            if (m/<lower>/ with $marker) {
                %distmap{ item [$key, $marker] } = $steps;
            }
        }
    }

    return %distmap;
}

my %distmap = gen-key-dist();
%distmap.say;

sub optimistic-dist($from, @keys) {
    (@keytexts (-) @keys).keys.map({ %distmap{ item [$_, $from] } }).max;
}

sub inbounds([$x, $y]) {
    0 <= $y <= @input.elems and 0 <= $x <= @input[0].elems;
}

sub adjacents([$x, $y]) {
    return (
        ($x, $y + 1),
        ($x, $y - 1),
        ($x - 1, $y),
        ($x + 1, $y)
    ).grep(&inbounds).pick(*);
}

my $best = Inf;
my %cache is default(False);

"starting".say;

sub search($x, $y, $depth, @keys) {
    if %cache{ item [$x, $y, @keys.Bag]} {
        return;
    }
    if $depth >= $best or ($depth + optimistic-dist(@input[$y][$x], @keys)) >= $best {
        return;
    }
    if @keys.elems == $keys {
        $best = min($best, $depth);
        "setting best to {$best}".say;
        return;
    }
    my %visited is default(False);
    my @frontier =  ($x, $y, $depth), ;
    my $keysfound = 0;
    while @frontier.elems > 0 {
        my $next = @frontier.shift;
        my $expand = $next[0..1];
        my $steps = $next[2];
        my $marker = @input[$expand[1]][$expand[0]];

        if $steps >= $best {
            return;
        }

        if ($keysfound + @keys.elems == $keys) {
            return;
        }
        if !%visited{ item $expand } and $marker !eq '#' and !( m/<upper>/ and !@keys.contains(item $_.lc) with $marker ) {
            %visited{ item $expand } = True;
            @frontier.push(($_.Slip, $steps + 1)) for adjacents($expand);
            if (m/<lower>/ and !@keys.contains($_) with $marker) {
                $keysfound++;
                my @option = [$marker, $steps, $expand];
                (my $newx, my $newy) = @option[2];
                my @newkeys = [|@keys.clone, @option[0]];
                search($newx, $newy, @option[1], @newkeys);
                %cache{item [$x, $y, @newkeys.Bag]} = True;
            }
        }
    }
}

search($startx, $starty, 0, []);

$best.say;