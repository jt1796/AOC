use PriorityQueue; #zef install PriorityQueue

my @input = slurp('18.txt').lines.map({ $_.comb.List }).List;
my ($startx, $starty) = key-location-of('@');
my @keytexts = @input.List.flat.grep( { m:g/<lower>/ } );
my $keycount = @keytexts.elems;

sub key-location-of($key) {
    my $starty = @input.first({ $_.contains($key) }, :k);
    my $startx = @input[$starty].first($key, :k);
    return ($startx, $starty);
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
    ).grep(&inbounds);
}

my %distmap;
my %blockmap is default(List.new);

sub gen-key-dist() {
    my @keysandstart = ('@', @keytexts).flat;
    my %locations = @keysandstart.map({ $_ => key-location-of($_) });

    for @keysandstart -> $key {
        my @frontier = ((%locations{ $key }.Slip, 0, List.new),);
        my %seen is default(False);

        while @frontier.elems > 0 {
            my $next = @frontier.shift;
            my $expand = $next[0..1];
            my $steps = $next[2];
            my @doors = $next[3].clone;
            my $marker = @input[$expand[1]][$expand[0]];

            next if $marker eq '#';
            next if %seen{ item $expand };
            %seen{ item $expand } = True;
            if (m/<lower>/ with $marker) {
                %distmap{ item [$key, $marker] } = $steps;
                %blockmap{ item [$key, $marker] } = @doors;
            }
            if (m/<upper>/ with $marker) {
                @doors.push($marker.lc);
            }
            @frontier.push(item [$_.Slip, $steps + 1, @doors]) for adjacents($expand);
        }
    }
}

gen-key-dist();

%distmap.say;
%blockmap.say;

my %cache is default(False);
my $bestdist = -Inf;
my $frontier = PriorityQueue.new(:cmp( { $^a[1] <= $^b[1] } ));

$frontier.push(item ('@', 0, List.new));
while $frontier.shift -> $removed {
    my $symbol = $removed[0];
    my $distance = $removed[1];
    my @keys = $removed[2].List;
    next if %cache{ item [$symbol, @keys.Bag] };
    %cache{ item [$symbol, @keys.Bag] } = True;

    if @keys.elems == $keycount {
        @keys.say;
        $distance.say;
        die;
    }

    if $bestdist != $distance {
        $distance.say;
        $bestdist = $distance;
    }

    my @options = (@keytexts (-) @keys (-) $symbol).keys
                    .grep({ defined %distmap{ item [$symbol, $_] } })
                    .grep({ so %blockmap{ item [$symbol, $_] }.all ∈ @keys });

    for @options -> $option {
        my @newkeys = @keys.clone.Slip, $option;
        my $newdistance = $distance + %distmap{ item [$symbol, $option] };
        $frontier.push( item [$option, $newdistance, @newkeys]);
    }
}