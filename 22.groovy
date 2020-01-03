deck = (0..(10007 - 1)) as LinkedList
def newstack() {
    println "newstack"
    newdeck = [] as LinkedList
    for (card in deck) {
        newdeck.addFirst(card)
    }
    deck = newdeck
}

def deal(int n) {
    println "deal $n"
    int pos = 0;
    newdeck = [] as LinkedList
    deck.size().times { newdeck.addFirst(-1) }
    while (!deck.isEmpty()) {
        newdeck.set(pos, deck.removeFirst())
        pos = (pos + n) % newdeck.size()
    }
    deck = newdeck
}

def cut(int n) {
    println "cut $n"
    def addr = n > 0 ? deck.&addLast   : deck.&addFirst
    def rmr =  n > 0 ? deck.&removeFirst  : deck.&removeLast
    Math.abs(n).times {
        addr(rmr())
    }
}

println deck

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

println deck
println deck.indexOf(2019)