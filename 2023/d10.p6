use PriorityQueue;
my $pq = PriorityQueue.new(:cmp(*[0]));

my @input = "d10.txt".IO.lines>>.comb>>.Array.Array;

sub findS() {
    (.[0], .[1].first("S", :k)) with @input.first("S" (elem) *, :kv);
}

my %dirs := { U => (-1, 0), D => (1, 0), L => (0, -1), R => (0, 1) };
my %mmap := {
    '|' => %dirs<U D>,
    '-' => %dirs<L R>,
    'L' => %dirs<U R>,
    'J' => %dirs<U L>,
    '7' => %dirs<L D>,
    'F' => %dirs<R D>,
    '.' => (),
    # 'S' => %dirs<D L>,
    'S' => %dirs<U R>,
};

$pq.push(findS());

my %seen;
sub findLoop($dist, $r, $c) {
    my $sym = @input[$r][$c] || '.';
    return {} if $sym eq '.';
    if $sym eq 'S' and $dist > 2 {
        say 'max: ' ~ solve(%seen.clone).elems;
        return %seen.clone;
    }
    return {} if %seen{ $r ~ '_' ~ $c }:exists;

    %seen{ $r ~ '_' ~ $c } = True;
    findLoop($dist + 1, .[0], .[1]) for (($r, $c), *) <<«+»>> %mmap{$sym};
    %seen{ $r ~ '_' ~ $c }:delete;
}

findLoop(0, |findS());

sub solve(%mainloop) {
    say 'mainloop size: ' ~ %mainloop.elems;
    my %outside;
    my %inside;
    sub paintregion($r, $c) {
        return if %inside{$r ~ '_' ~ $c}:exists or %outside{$r ~ '_' ~ $c}:exists or %mainloop{$r ~ '_' ~ $c}:exists;

        my %painted;
        sub paint($r, $c) {
            my $str = $r ~ '_' ~ $c;
            return if %mainloop{ $str }:exists;
            return if %painted{ $str }:exists;
            return unless @input[$r][$c];
            %painted{ $str } = True;

            paint(.[0], .[1]) for (($r, $c), *) <<«+»>> %dirs<U D L R>;
        }

        paint($r, $c);

        my @ray = (.[0], .[0] + 1 ... .[0] + 1000) <<,>> .[1] with %painted.keys.first.split('_');
        my $symbag = @ray.grep({ %mainloop{ .[0] ~ '_' ~ .[1] }:exists }).map({ @input[.[0]][.[1]] || '.' }).Bag;
        my $crossings = $symbag{'-'};

        $crossings += ($symbag{'7'} - $symbag{'J'} + $symbag{'L'} + $symbag{'S'} - $symbag{'F'}) / 2;

        if not $crossings %% 2 {
            %inside = (%inside >>or<< %painted);
        } else {
            %outside = (%outside >>or<< %painted);
        }

        say %inside.elems;
    }


    for @input.kv -> $r, @row {
        for @row.kv -> $c, $sym {
            paintregion($r, $c);
        }
    }

    return %inside;
}

#468 too high
