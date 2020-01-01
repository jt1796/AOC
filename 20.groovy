input = new File('20.txt').readLines().collect({ it.getChars() });

def ingraph(x, y) {
    return x > 0 && x < (input[0].size() - 1) && y > 0 && y < (input.size() - 1) &&
        [left, right, up, down].any({ dir -> '.' == getAt(dir([x, y])) })
}

def findchars() {
    def positions = [] as Set;
    (0..input.size() - 1).each { y ->
        (0..input[y].size() - 1).each { x ->
            if (input[y][x].isLetter()) {
                positions.add([x, y]);
            }
        }
    }

    return positions;
}

left = { loc -> [loc[0] - 1, loc[1]] }
right = { loc -> [loc[0] + 1, loc[1]] }
up = { loc -> [loc[0], loc[1] - 1] }
down = { loc -> [loc[0], loc[1] + 1] }

getAt = { loc -> input[loc[1]][loc[0]] }
getWordAtDir = { loc, dir -> 
    def tag = false
    if (charlocations.contains(dir(loc))) {
        tag = '' + getAt(loc) + getAt(dir(loc))
        if (dir.is(left) || dir.is(up)) {
            tag = tag.reverse()
        }
    }
    return tag
}
getWordAtAnyDir = { loc -> [left, right, up, down].collect({ getWordAtDir(loc, it) }).find({ it }) }

charlocations = findchars();
taglocations = charlocations.findAll({ ingraph(*it) });
portals = taglocations.collectEntries({ [it, getWordAtAnyDir(it)] })

def inbounds(x, y) {
    return x > 0 && x < input[0].size() && y > 0 && y < input.size()  
}

def getDirectNeighbors(x, y) {
        return [left, right, up, down].collect({ it([x, y]) }).findAll({inbounds([*it])})
}

def getneighbors(x, y) {
    if (getAt([x, y]) == '.') {
        return getDirectNeighbors(x, y);
    }
    if (getAt([x, y]).isLetter()) {
        def tag = portals[[x, y]];
        def commonLocations = portals.keySet().findAll({ portals[it] == tag && it != [x, y] });
        def neighbors = []
        commonLocations.forEach({ neighbors.addAll(getDirectNeighbors(*it)) });
        return neighbors.findAll({ getAt(it) == '.' })
    }
}

def isouter(loc) {
    def x = loc[0]
    def y = loc[1]
    return y == 1 || y == (input.size() - 2) || x == 1 || x == (input[0].size() - 2)
}

println portals;
locationAA = portals.keySet().find({ portals[it] == 'AA' })
frontier = new PriorityQueue({ a, b -> a[1] - b[1] })
frontier.add([up(locationAA), -1, 0, []])
seen = [:]

while (frontier.size() > 0) {
    def removed = frontier.remove()
    def location = removed[0]
    def steps = removed[1]
    def level = removed[2]
    def path = removed[3]
    
    if (seen[location, level] || (getAt(location) == '#') || level < 0) {
        continue
    } else {
        seen[location, level] = true
    }

    if (portals[location] == 'ZZ' && (level == 0)) {
        println steps
        println level
        println path
        println path.size()
        System.exit(0)
    }

    def islevel = 0
    def isstep = 1
    if (portals[location]) {
        isstep = 0
        if (level == 0 && isouter(location) && portals[location] != 'AA') {
            continue
        }
        if (level > 0 && (portals[location] == 'ZZ' || portals[location] == 'AA')) {
            continue
        }
        if (isouter(location)) {
            islevel--;
        } else {
            islevel++;
        }
    }

    def neighbors = getneighbors(*location)
    def newpath = path.collect()
    if (portals[location]) {
        newpath.push(portals[location])
        newpath.push(level + islevel)
    }

    for (neighbor in neighbors) {
        frontier.add([neighbor, steps + isstep, level + islevel, newpath])
    }
}




// method for "inner" or "outer" level