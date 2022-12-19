const fs = require('fs');
const LRU = require("lru-cache");

const cache = new LRU(500);
const contents = fs.readFileSync('d14.txt').toString().split(/\n/);
const chain = contents[0];
const rules = contents.filter(l => l.includes(' -> '));

const midcache = {};
function mid(s1, s2) {
    const key = `${s1}${s2}`;
    if (midcache[key]) {
        return midcache[key];
    }
    midcache[key] = rules.find(r => r.startsWith(`${s1}${s2}`)).slice(-1);

    return midcache[key];
}

function calc(level, at) {
    const key = `${level}-${at}`;
    if (cache.has(key)) {
        return cache.get(key);
    }
    if (level === 0) {
        return chain[at];
    }

    if (at % 2 === 0) {
        cache.set(key, calc(level - 1, at / 2));
    } else {
        cache.set(key, mid(calc(level - 1, Math.floor(at / 2)), calc(level - 1, Math.floor(at / 2 + 1))));
    }

    return cache.get(key);
}

function diameter(level) {
    let dia = chain.length;
    while (level-- > 0) {
        dia = dia * 2 - 1;
    }

    return dia;
}

const start = new Date().valueOf();
const level = 40;
const dia = diameter(level);
const cnts = {};
rules.forEach(r => {
    const last = r.slice(-1);
    cnts[last] = 0;
});
console.log(dia);
for (let i = 0; i < dia; i++) {
    if (i % 100000 === 0) {
        const timeDiff = (new Date().valueOf() - start) / 1000 / 3600;
        const frac = i / dia;
        console.log(`${timeDiff / frac - timeDiff} hours remaining. ${100 * frac}% done: ${i} loops`);
    }
    cnts[calc(level, i)]++;
}

const vals = Object.values(cnts);
console.log(Math.max(...vals) - Math.min(...vals));