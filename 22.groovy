decksize = 10007 as BigInteger
position = 2019

// 3377

def newstack() {
    position = decksize - position - 1 
}

def deal(int n) {
    position = ((n * position) % decksize)
}

def cut(int n) {
    position = (position - n + decksize) % decksize
}

moves = new File('22.txt').readLines().collect{ it.split(' ') }
for (move in moves) {
    if (move == ['deal', 'into', 'new', 'stack']) {
        newstack()
    }
    if (move.size() > 2 && move[0..2] == ['deal', 'with', 'increment']) {
        deal(move[3].toInteger())
    }
    if (move[0] == 'cut') {
        cut(move[1].toInteger())
    }
}

println position