def matches(list, idx, x, y) {
    def grid = list.get(idx)
    def count = 0
    if (x >= 1 && grid[y][x - 1] == '#') {
        count++
    }
    if (y >= 1 && grid[y - 1][x] == '#') {
        count++
    }
    if (y < 4 && grid[y + 1][x] == '#') {
        count++
    }
    if (x < 4 && grid[y][x + 1] == '#') {
        count++
    }

    if (idx > 0) {
        def above = list.get(idx - 1)
        if (y == 0 && above[1][2] == '#') {
            count++
        }
        if (y == 4 && above[3][2] == '#') {
            count++
        }
        if (x == 0 && above[2][1] == '#') {
            count++
        }
        if (x == 4 && above[2][3] == '#') {
            count++
        }
    }

    if (idx < list.size() - 1) {
        def prevcount = count
        def below = list.get(idx + 1)
        if (x == 2 && y == 1) {
            count += checkrow(below, 0)
        }
        if (x == 2 && y == 3) {
            count += checkrow(below, 4)
        }
        if (x == 1 && y == 2) {
            count += checkcol(below, 0)
        }
        if (x == 3 && y == 2) {
            count += checkcol(below, 4)
        }
    }

    return count
}

def checkrow(grid, r) {
    def sum = 0
    (0..4).each {
        if (grid[r][it] == '#') {
            sum++
        }
    }
    sum
}

def checkcol(grid, c) {
    def sum = 0
    (0..4).each {
        if (grid[it][c] == '#') {
            sum++
        }
    }
    sum
}

def advance(list) {
    def newlist = [] as LinkedList

    for (int i = 0; i < list.size(); i++) {
        newlist.addLast(advancegrid(list, i))
    }
    return newlist
}

def advancegrid(list, idx) {
    def grid = list.get(idx)
    def newgrid = [];
    for (int y = 0; y < 5; y++) {
        def row = [];
        for (int x = 0; x < 5; x++) {
            if (x == 2 && y == 2) {
                row.add('?')
                continue
            }
            def next = grid[y][x];
            def nearbugs = matches(list, idx, x, y)
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

def blank() {
    def grid = (0..4).collect {
        (0..4).collect { '.' }
    }
    grid[2][2] = '?'
    return grid
}

def printlist(list) {
    level = -1 * (list.size() - 1 ) / 2
    list.each {
        println '----__' + (level++) + '__------'
        printgrid(it)
    }
}

def printgrid(grid) {
    for (row in grid) {
        println row
    }
}

def countbugs(list) {
    list.collect({ g-> 
        g.flatten().findAll({it == '#'}).size()
    }).sum();
}


def list = [] as LinkedList
list.addFirst(new File('24.txt').readLines().collect{ it.getChars() as List })
def iters = 200
iters.times {
    list.addFirst(blank())
    list.addLast(blank())
}

iters.times {
    list = advance(list)
}
//printlist(list)
println countbugs(list)
