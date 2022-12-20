const input = `Blueprint 1: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 4 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 19 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 3: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 14 clay. Each geode robot costs 4 ore and 15 obsidian.`;

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

    const maxTime = 32;
    const start = new Date().valueOf();

    const solve = (time, have, rates) => {
        if (have.geode > max) {
            console.log('updating max to', have.geode,  'in', Math.round((new Date().valueOf() - start) / 1000), 's');
            max = have.geode;
        }
        if (time == maxTime) return have.geode;
        const timeLeft = maxTime - time;

        let geodeUpperBound = have.geode;
        for (let i = 0; i < timeLeft; i++) {
            geodeUpperBound += rates.geode + i;
        }
        if (geodeUpperBound < max) return have.geode;

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

        if (maxOreNeeded * timeLeft > have.ore) have.ore = maxOreNeeded * timeLeft;
        if (maxClayNeeded * timeLeft > have.clay) have.clay = maxClayNeeded * timeLeft;
        if (maxObsidianNeeded * timeLeft > have.obsidian) have.obsidian = maxObsidianNeeded * timeLeft;

        return Math.max(...candidates);
    };
    const answer = solve(0, { ...have }, { ...rates });
    console.log(id, ' ~ ', answer);
    return answer;
});

console.log(scores.reduce((a, b) => a * b));

// 4416 too low (24, 23, 8)
//               30, 26, 

// 56, 62 in example