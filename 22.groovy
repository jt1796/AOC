decksize = 119315717514047 as BigInteger
initialposition = 2020 as BigInteger
position = initialposition

def multiply(BigInteger n) {
    position = ((n.modInverse(decksize) * position) % decksize)
}

def add(BigInteger n) {
    position = (position + n + decksize) % decksize
}

moves = new File('22.txt').readLines().collect{ it.split(' ') }
def shuffle() {
    for (move in moves.reverse()) {
        if (move[0] == 'multiply') {
            multiply(move[1].toBigInteger())
        }
        if (move[0] == 'add') {
            add(move[1].toBigInteger())
        }
    }
}
    
shuffle()
println position
shuffle()
println position
shuffle()
println position