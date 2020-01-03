decksize = 10007 as BigInteger
position = 3377 as BigInteger

// 2019 expected. What number is in that position?

def newstack() {
    position = decksize - position - 1 
}

def deal(BigInteger n) {
    position = ((n.modInverse(decksize) * position) % decksize)
}

def cut(int n) {
    position = (position + n + decksize) % decksize
}

moves = new File('22.txt').readLines().collect{ it.split(' ') }
for (move in moves.reverse()) {
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