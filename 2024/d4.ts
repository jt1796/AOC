import { cross } from "./common.js";

const grid = "d4.txt".readStringGrid();

const dirs = cross([[-1, 0, 1], [-1, 0, 1]]).map(([x, y]) => [0, 1, 2, 3].map(mag => [x * mag, y * mag]));

grid.flatMap((row, x) => {
    return row.flatMap((i, y) => {
        return dirs.flatMap((pairs) => {
            return pairs.map(([dx, dy]) => grid[x + dx]?.[y + dy]).join('') === "XMAS";
        });
    });
}).sum().print();
