grid = new File('24.txt').readLines().collect{ it.getChars() as List }

def matches(grid, x, y, symbol) {
    def count = 0
    if (x >= 1 && grid[y][x - 1] == symbol) {
        count++
    }
    if (y >= 1 && grid[y - 1][x] == symbol) {
        count++
    }
    if (y + 1 < grid.size() && grid[y + 1][x] == symbol) {
        count++
    }
    if (x + 1 < grid[0].size() && grid[y][x + 1] == symbol) {
        count++
    }

    return count
}

def advance(grid) {
    def newgrid = [];
    for (int y = 0; y < grid.size(); y++) {
        def row = [];
        for (int x = 0; x < grid[0].size(); x++) {
            def next = grid[y][x];
            def nearbugs = matches(grid, x, y, '#')
            if (next == '#') {
                if (nearbugs != 1) {
                    next = '.'
                }
            } else {
                if (nearbugs == 1 || nearbugs == 2 ) {
                    next = '#'
                }
            }
            row.add(next);
        }
        newgrid.add(row);
    }
    return newgrid;
}

def hash(grid) {
    def sum = 0
    def power = 1
    grid.flatten().each({
        if (it == '#') {
            sum += power
        }
        power *= 2
    });

    return sum
}

def printgrid(grid) {
    for (row in grid) {
        println row
    }
}

hashes = [] as Set
curhash = hash(grid)
while (!hashes.contains(curhash)) {
    hashes.add(curhash)
    grid = advance(grid)
    curhash = hash(grid)
}

println curhash