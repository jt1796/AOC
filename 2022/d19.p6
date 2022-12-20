my @blueprints = open('d19.txt').lines;

say @blueprints.map({
    my %costs = ore => { }, clay => { }, obsidian => { }, geode => { };

    my $id = 0;

    for .split(/\.|\:/) {
        when /Blueprint/ { $id = .comb(/\d+/)[0] }
        when /(\w+)\srobot\scosts\s((\d+)\s(\w+)\D*)+/ { %costs{$/[0].Str}{.[1].Str} = .[0].Int for $/[1] }
    }

    if $id ne 210 {
        my $solved = solve(%costs);
        say $id ~ ' ~ ' ~ $solved;
        $solved * $id;
    }
}).sum;

sub solve(%costs) {
    my %have = ore => 0, clay => 0, obsidian => 0, geode => 0;
    my %rates = ore => 1, clay => 0, obsidian => 0, geode => 0;

    my %timecache;

    my %limits = %costs.values>>.list.flat.>>.Hash.reduce({ %^a >>max<< %^b });

    sub tick($time, %have, %rates) {
        my $timeleft = 24 - $time;
        return %have<geode> if $time >= 24;

        ## time cache ##
        my $timekey = (%have.kv.sort, %rates.kv.sort).Str;
        return 0 if (%timecache{$timekey} or Inf) <= $time;
        %timecache{$timekey} = $time;

        sub budget($kv) { %have{$kv.key} >= $kv.value };
        my @options = %costs.grep({ so budget(.value.all) }).map(*.key);

        %have = %have >>+<< %rates;

        my @pruned; # = %limits.pairs.grep({ %rates{.key} >= .value })>>.key;

        # my %havelimit = %limits.map({ .key => .value * ($timeleft) });
        # %have = %have >>min<< %havelimit;

        return [
            |[tick($time + 1, %have >>-<< %costs{$_}, %rates >>+<< %($_ => 1)) for (@options (-) @pruned).keys],
            tick($time + 1, %have.Hash, %rates.Hash),
        ].max
    }

    return tick(0, %have, %rates);
}


# 960 too low. Also someone elses answer


# do geodes last?