my @rows = "d14.txt".IO.lines>>.comb>>.Array;

sub cycle() {
    roll([Z] @rows);
    roll(@rows);
    roll(([Z] @rows)>>.reverse);
    roll(@rows>>.reverse);

    weight([Z] @rows);
}

sub weight(@rows) {
    my $total = 0;
    for @rows -> @row {
        for @row.kv -> $idx, $sym {
            $total += +@row - $idx if $sym eq 'O';
        }
    }

    $total;
}

sub roll(@rows) {
    my $total = 0;
    for @rows -> @row {
        my $rocks = 0;
        for @row.kv.reverse -> $sym, $idx {
            LAST {
                $total += $rocks * (+@row - $rocks / 2);
                @row[$_] = 'O' for (0 ...^ $rocks);
            }
            if $sym eq '#' {
                $total += $rocks * (+@row - $idx - 2 - $rocks / 2 );
                @row[$_] = 'O' for ($idx + 1 ...^ $idx + 1 + $rocks);
                $rocks = 0;
            }
            if $sym eq 'O' {
                @row[$idx] = '.';
                $rocks++;
            }
        }
    }

    $total;
}

my @seq = (^Inf).map({ cycle() }).cache;

my @keys = @seq.skip(200).rotor(10 => -9);

my $period = [R-] @keys.grep({ $_ eq @keys[0] }, :k)[^2];

say @seq[200 + (1000000000 - 200) mod $period - 1];
