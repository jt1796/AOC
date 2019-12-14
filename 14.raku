my @reactions = slurp('14.txt').lines.map({ m:g/\w+/.map({ .Str }) });

sub reaction-applies(@reaction, %stuff) {
    !@reaction[0..*-3].rotor(2).first({ %stuff{ $_[1] } < $_[0] } );
}

sub apply-reaction(@reaction, %stuff) {
    my %newstuff is default(0) = %stuff.clone;
    %newstuff{$_[1]} -= $_[0] for @reaction.rotor(2);
    %newstuff{ @reaction[* - 1] } += 2 * @reaction[* - 2];
    %newstuff;
}

my %visited is default(0);

# additional param. "blacklisted reactions" and "current reaction". 
sub leads-to-fuel(%stuff, @usedrxns) {
    return True if %stuff{ 'FUEL' } > 0;
    return False if %visited{ item %stuff } > 0;
    %visited{ item %stuff } = 1;

    for @reactions -> @reaction {
        next if @usedrxns.contains(@reaction);
        my %newstuff is default(0) = %stuff.clone;
        while (reaction-applies(@reaction, %newstuff)) {
            %newstuff = apply-reaction(@reaction, %newstuff);
            return True if leads-to-fuel(%newstuff, [@reaction, |@usedrxns]);
        }
    }

    return False;
}

sub try-with-ore($ore) {
    my %stuff is default(0) = 'ORE' => $ore;
    leads-to-fuel(%stuff, []);
}

say try-with-ore(13312);

