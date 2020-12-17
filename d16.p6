use experimental :cached;

my @constraints;

my @ticket;
my @nearby;

my $state = 'rules';
for open('d16.txt').lines -> $line {
    if ($line eq "") {
        next;
    }
    if ($line.contains('your ticket')) {
        $state = 'mine';
        next;
    }
    if ($line.contains('nearby ticket')) {
        $state = 'nearby';
        next;
    }

    if ($state eq 'rules') {
        $line ~~ m:g/(\d+)\-(\d+)/;
        @constraints.push(($/[0][0..1].map({ .Str.Int }), $/[1][0..1].map({ .Str.Int })));
    }
    if ($state eq 'mine') {
        @ticket =$line.split(',').map({ .Int });
    }
    if ($state eq 'nearby') {
        @nearby.push($line.split(',').map({ .Int }));
    }
}

my @possibles = @nearby.grep(-> @ticket {
    so @ticket.map(-> $num {
        so @constraints.map({ so $_.map({ $_[0] <= $num <= $_[1] }).any }).any;
    }).all;
});

my $fieldcnt = @ticket.elems;

my %rule2loc;

sub whichrulesonfield($fieldno) {
    my @fields = @possibles.map: *.[$fieldno];
    (@constraints.keys (-)%rule2loc.keys.map: *.Int).keys.grep(-> $i {
        my @c = @constraints[$i];
        so @fields.map(-> $num {
            so @c.map({ so $_.map({ $_[0] <= $num <= $_[1] }).any }).any;
        }).all;
    }).list;
}

while %rule2loc.elems < $fieldcnt {
    (^$fieldcnt).first({
        my @cands = whichrulesonfield($_);
        if (@cands.elems == 1) {
            %rule2loc{@cands[0]} = $_;
            True;
        } else {
            False;
        }
    });
}

say [*] (^6).map({ @ticket[%rule2loc{$_}] })