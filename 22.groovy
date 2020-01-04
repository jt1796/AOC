decksize = 119315717514047 as BigInteger
initialposition = 2020 as BigInteger
position = initialposition

def multiply(BigInteger n) {
    position = ((n.modInverse(decksize) * position) % decksize)
}

def add(BigInteger n) {
    position = (position + n + decksize) % decksize
}

//           multiply                      add
primitive = [70684449757251 as BigInteger, 53942452021304 as BigInteger]

def shuffle(formula) {
    add(formula[1])
    multiply(formula[0])
}

def shuffleN(n) {
    n.times {
        shuffle(primitive)
    }
}
    
shuffleN(16)
println position

position = initialposition

// use formula to get to 97 shuffles
def squareformula(formula) {
    return [formula[0] * formula[0], formula[1] + formula[0] * formula[1]]
}

def formula = primitive
4.times {
    formula = squareformula(formula)
}
shuffle(formula)
println position