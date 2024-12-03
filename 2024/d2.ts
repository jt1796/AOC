import { zip } from "./common.js";

const answer = "d2.txt".readNumsLines().map(line => {
    return line.range().some(pos => {
        const dropped = line.spliced(pos, 1);

        const pairs = zip(dropped, dropped.spliced(0, 1));

        const isAscending = pairs.every(([a, b]) => a >= b);
        const isDescending = pairs.every(([a, b]) => a <= b);
        const isTight = pairs.map(([a, b]) => Math.abs(a - b)).every(n => n >= 1 && n <= 3);
        
        return (isAscending || isDescending) && isTight;
    });
}).sum();

console.log({ answer });
