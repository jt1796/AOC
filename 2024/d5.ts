import "./common.js";

const [ins, ex] = "d5.txt".readString().split(/\r?\n\r?\n/).map(p => p.lines().map(s => s.getWords()));

const keyBefore = ins.groupBy(k => k[0]);
const keyAfter = ins.groupBy(k => k[1]);

ex.map((line) => {
    const valid = line.every((word, idx) => {
        const rulesBefore = keyBefore[word] || [];
        const rulesAfter = keyAfter[word] || [];

        const a = rulesBefore.map(r => r[1]).filter(r => line.includes(r)).every(r => line.indexOf(r) > idx);
        const b = rulesAfter.map(r => r[0]).filter(r => line.includes(r)).every(r => line.indexOf(r) < idx);

        return a && b;
    });

    line.sort((a, b) => {
        if ((keyBefore[a] || []).some(r => r[1] === b)) {
            return 1;
        }

        if ((keyBefore[b] || []).some(r => r[1] === a)) {
            return -1;
        }

        return 0;
    });

    return valid ? 0 : +line[Math.floor(line.length / 2)];
}).sum().print();
