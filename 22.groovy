decksize = 119315717514047 as BigInteger
initialposition = 2020 as BigInteger
position = initialposition

def deal(BigInteger n) {
    position = ((n.modInverse(decksize) * position) % decksize)
}

def cut(int n) {
    position = (position + n + decksize) % decksize
}

moves = new File('22.txt').readLines().collect{ it.split(' ') }
def shuffle() {
    for (move in moves.reverse()) {
        if (move.size() > 2 && move[0..2] == ['deal', 'with', 'increment']) {
            deal(move[3].toInteger())
        }
        if (move[0] == 'cut') {
            cut(move[1].toInteger())
        }
    }
}
    
shuffle()
println position
shuffle()
println position
shuffle()
println position