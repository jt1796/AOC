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
    
shuffleN(97)
println position
position = initialposition

// use formula to get to 97 shuffles
def doubleformula(formula) {
    return [formula[0] * formula[0], formula[1] + formula[0] * formula[1]]
}

def mults = 97
while (mults > 0) {
    int log = Math.log(mults) / Math.log(2)
    System.out.println(log)
    mults -= Math.pow(2, log)

    def formula = primitive
    log.times {
        formula = doubleformula(formula)
    }
    shuffle(formula)
}

println position