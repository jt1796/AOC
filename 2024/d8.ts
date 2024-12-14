import { range } from "./common.js";

const grid = "d8.txt".readStringGrid();
const symbolMap = grid.gridSymbolMap();
delete symbolMap['.'];

const notUnique = Object.entries(symbolMap).flatMap(([symbol, locs]) => 
    locs.pairs().flatMap(([p1, p2]) => {
        const diff = p2.sub(p1);
        return range(-20, 20).flatMap(m => {
            const newDiff = [diff[0] * m, diff[1] * m];
            return [p1.sub(newDiff), p2.add(newDiff)];
        });
    }).filter(p => !!grid.gridIndex(p))
);

new Set(notUnique.map(a => a.join(','))).size.print();
