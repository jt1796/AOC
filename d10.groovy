jolts = new File('d10.txt').readLines().collect { it.toInteger() }.sort();

// 30: 7.1 - 5.5
// 35: 7 - 5.5
// 40: 10.7 - 5.5
// 45: 32s - 5.5
// 50: 1m45s - 5.5       tripling every 5
// 13

target = jolts.max();

def countperms(jolts, curvolts) {
    if (curvolts >= target) {
        return 1;
    }
    def candidates = jolts.subList(0, Math.min(4, jolts.size())).findAll { curvolts < it && it <= curvolts + 3 };
    if (candidates.isEmpty()) {
        return 0;
    }
    return candidates.collect({ x ->
        countperms(jolts.findAll({ it != x }), x);
    }).sum();
}

println countperms(jolts, 0);