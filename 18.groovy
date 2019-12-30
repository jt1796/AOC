def solve(xbounds, ybounds) {
    def input = new File('18.txt').readLines()[ybounds].collect({ it.getChars()[xbounds] });
    //input.forEach({ println it });

    def keylocationof = { key ->
        def starty = input.findIndexOf({ it.contains(key) });
        def startx = input[starty].findIndexOf({ it == key });
        return [startx, starty];
    }

    def inbounds = { x, y ->
        0 <= y && y <= input.size() && 0 <= x && x <= input[0].size();
    }

    def adjacents = { x, y ->
        return [
            [x, y + 1],
            [x, y - 1],
            [x - 1, y],
            [x + 1, y]
        ].findAll({ inbounds(it) });
    }

    def keytexts = input.flatten().findAll( { it.isLowerCase() } );
    def keycount = keytexts.size();

    def distmap = [:];
    def blockmap = [:].withDefault({ [] });
    def keysalongpath = [:].withDefault({ [] });

    def keysandstart = ['@' as char, keytexts].flatten();
    def locations = keysandstart.collectEntries({ return [it, keylocationof(it)] });

    for (key in keysandstart) {
        def frontier = [[locations[key][0], locations[key][1], 0, [], []]] as Queue;

        def seen = [:].withDefault({ false });

        while (frontier.size() > 0) {
            def next = frontier.poll();
            def expand = next[0..1];
            def steps = next[2];
            def doors = next[3].collect();
            def pickedupkeys = next[4].collect();
            def marker = input[expand[1]][expand[0]];

            if (marker == '#') {
                continue;
            }
            if (seen[expand]) {
                continue;
            }
            seen[expand] = true;
            if (marker.isLowerCase()) {
                distmap[[key, marker]] = steps;
                blockmap[[key, marker]] = doors;
                pickedupkeys.push(marker);
                keysalongpath[[key, marker]] = pickedupkeys;
            }
            if (marker.isUpperCase() && keytexts.contains(marker.toLowerCase())) {
                doors.push(marker.toLowerCase());
            }
            for (adjacent in adjacents(expand)) {
                frontier.push([adjacent[0], adjacent[1], steps + 1, doors, pickedupkeys]);
            }
        }
    }

    // println distmap;
    // println blockmap;

    def cache = [:].withDefault({ false });
    def bestdist = 9999999999;
    def frontier = new PriorityQueue({ a, b -> a[1] - b[1] });

    println "starting";

    frontier.add(['@' as char, 0, []]);
    while (frontier.size() > 0) {
        removed = frontier.remove();
        def symbol = removed[0];
        def distance = removed[1];
        def keys = removed[2];
        if (cache[[symbol, keys.toSet()]]) {
            continue;
        }
        cache[[symbol, keys.toSet()]] = true;

        if (distance >= bestdist) {
            continue;
        }

        if (keys.size() == keycount) {
            bestdist = Math.min(bestdist, distance);
            println keys;
            println distance;
        }


        def options = (keytexts - keys - [symbol])
                        .findAll({ null != distmap[[symbol, it]] })
                        .findAll({ blockmap[[symbol, it]].every({ keys.contains(it) }) })
                        .collect({ keysalongpath[[symbol, it]].find({ !keys.contains(it) }) })
                        .sort({ -1 * distmap[[symbol, it]] })
                        .unique();

        for (option in options) {
            def newkeys = [keys.collect(), option].flatten().unique();
            def newdistance = distance + distmap[[symbol, option]];
            frontier.add([option, newdistance, newkeys]);
        }
    }

    return bestdist;
}

println([
    solve(40..80, 40..80),
    solve(0..40, 0..40),
    solve(40..80, 0..40),
    solve(0..40, 40..80),
].sum());
