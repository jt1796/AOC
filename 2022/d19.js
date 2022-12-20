const input = `Blueprint 1: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 4 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 19 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 3: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 14 clay. Each geode robot costs 4 ore and 15 obsidian.
Blueprint 4: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 16 clay. Each geode robot costs 2 ore and 8 obsidian.
Blueprint 5: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 4 ore and 8 obsidian.
Blueprint 6: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 7 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 7: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 8 clay. Each geode robot costs 2 ore and 18 obsidian.
Blueprint 8: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 4 ore and 15 clay. Each geode robot costs 4 ore and 9 obsidian.
Blueprint 9: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 20 clay. Each geode robot costs 2 ore and 12 obsidian.
Blueprint 10: Each ore robot costs 3 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 20 clay. Each geode robot costs 2 ore and 12 obsidian.
Blueprint 11: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 12: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 16 clay. Each geode robot costs 2 ore and 9 obsidian.
Blueprint 13: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 15 clay. Each geode robot costs 3 ore and 20 obsidian.
Blueprint 14: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 17 clay. Each geode robot costs 4 ore and 16 obsidian.
Blueprint 15: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 16 clay. Each geode robot costs 3 ore and 15 obsidian.
Blueprint 16: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 18 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 17: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 11 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 18: Each ore robot costs 3 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 9 clay. Each geode robot costs 2 ore and 10 obsidian.
Blueprint 19: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 19 clay. Each geode robot costs 4 ore and 12 obsidian.
Blueprint 20: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 4 ore and 9 obsidian.
Blueprint 21: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 7 clay. Each geode robot costs 3 ore and 10 obsidian.
Blueprint 22: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 10 clay. Each geode robot costs 2 ore and 14 obsidian.
Blueprint 23: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 15 clay. Each geode robot costs 2 ore and 13 obsidian.
Blueprint 24: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 7 clay. Each geode robot costs 4 ore and 17 obsidian.
Blueprint 25: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 20 clay. Each geode robot costs 2 ore and 10 obsidian.
Blueprint 26: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 8 clay. Each geode robot costs 3 ore and 19 obsidian.
Blueprint 27: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 20 clay. Each geode robot costs 3 ore and 14 obsidian.
Blueprint 28: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 15 clay. Each geode robot costs 2 ore and 13 obsidian.
Blueprint 29: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 17 clay. Each geode robot costs 3 ore and 19 obsidian.
Blueprint 30: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 13 clay. Each geode robot costs 3 ore and 11 obsidian.`;

const lines = input.split('\n').map(s => s.match(/(\d+)/g));
const scores = lines.map(line => {
    const id = +line[0];
    const oreForOre = +line[1];
    const oreForClay = +line[2];
    const oreForObsidian = +line[3];
    const clayForObsidian = +line[4];
    const oreForGeode = +line[5];
    const obsidianForGeode = +line[6];

    const have = { ore: 0, clay: 0, obsidian: 0, geode: 0 };
    const rates = { ore: 1, clay: 0, obsidian: 0, geode: 0 };

    const cache = {};

    let max = 0;

    const maxTime = 24;

    const solve = (time, have, rates) => {
        max = Math.max(max, have.geode);
        if (time == maxTime) return have.geode;

        const cacheKey = JSON.stringify([have, rates]);
        if (!!cache[cacheKey] && time >= cache[cacheKey]) {
            return have.geode;
        } else {
            cache[cacheKey] = time;
        }

        const maxOreNeeded = Math.max(oreForOre, oreForClay, oreForObsidian, oreForGeode);
        const maxClayNeeded = clayForObsidian;
        const maxObsidianNeeded = obsidianForGeode;

        const options = [];
        if (oreForOre <= have.ore && maxOreNeeded >= rates.ore) options.push('ore');
        if (oreForClay <= have.ore && maxClayNeeded >= rates.clay) options.push('clay');
        if (oreForObsidian <= have.ore && clayForObsidian <= have.clay && maxObsidianNeeded >= rates.obsidian) options.push('obsidian');
        if (oreForGeode <= have.ore && obsidianForGeode <= have.obsidian) options.push('geode');

        Object.keys(rates).forEach(gem => have[gem] += rates[gem]);

        const candidates = [];
        if (options.includes('geode')) {
            candidates.push(solve(time + 1, { ...have, ore: have.ore - oreForGeode, obsidian: have.obsidian - obsidianForGeode }, { ...rates, geode: rates.geode + 1 }));
        }
        if (options.includes('obsidian')) {
            candidates.push(solve(time + 1, { ...have, ore: have.ore - oreForObsidian, clay: have.clay - clayForObsidian }, { ...rates, obsidian: rates.obsidian + 1 }));
        }
        if (options.includes('clay')) {
            candidates.push(solve(time + 1, { ...have, ore: have.ore - oreForClay }, { ...rates, clay: rates.clay + 1 }));
        }
        if (options.includes('ore')) {
            candidates.push(solve(time + 1, { ...have, ore: have.ore - oreForOre }, { ...rates, ore: rates.ore + 1 }));
        }
        if (options.length !== 4) {
            candidates.push(solve(time + 1, { ...have }, { ...rates }));
        }

        const timeLeft = maxTime - time;
        if (maxOreNeeded * timeLeft > have.ore) have.ore = maxOreNeeded * timeLeft;
        if (maxClayNeeded * timeLeft > have.clay) have.clay = maxClayNeeded * timeLeft;
        if (maxObsidianNeeded * timeLeft > have.obsidian) have.obsidian = maxObsidianNeeded * timeLeft;

        return Math.max(...candidates);
    };
    const answer = solve(0, { ...have }, { ...rates });
    console.log(id, ' ~ ', answer);
    return id * answer;
});

console.log(scores.reduce((a, b) => a + b));
