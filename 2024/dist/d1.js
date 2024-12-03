import "./common.js";
const nums = "d1.txt".readNums();
const evens = nums.chunk(1, 1, 0).flat();
const odds = nums.chunk(1, 1, 1).flat().groupBy((n) => n.toString()).mapValues(l => l.length);
const answer = evens.map(n => n * odds[n.toString()] || 0).sum();
console.log({ answer });
