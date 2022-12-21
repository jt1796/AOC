const { readFileSync } = require("fs");
const input = readFileSync('./d21.txt').toString().split('\n').map(s => s.split(":"));
input.map(l => l[1] = l[1].trim().split(' '));

const fnTable = {};

input.map(line => {
    const fn = () => {
        if (line[1].length === 1) return +line[1][0];
        const [l, op, r] = line[1];
        const lv = fnTable[l]();
        const rv = fnTable[r]();
        if (line[0] === "root") return lv - rv;
        if (op === "+") return lv + rv;
        if (op === "-") return lv - rv;
        if (op === "/") return lv / rv;
        if (op === "*") return lv * rv;

    };

    fnTable[line[0]] = fn;
});

for (let i = 3769668716700; i < 3769668716710; i += 1) {
    fnTable.humn = () => i;

    console.log(i, fnTable.root());
}