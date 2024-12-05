import "./common.js";

const grid = "d4.txt".readStringGrid();

const dirsA = [[-1, -1], [0, 0], [1, 1]];
const dirsB = [[-1, 1], [0, 0], [1, -1]];

grid.flatMap((row, x) => 
    row.flatMap((i, y) => 
        [dirsA, dirsB].every(dir => dir.map(([dx, dy]) => grid[x + dx]?.[y + dy]).join('') in { 'MAS': 1, 'SAM': 1 })
    )
).sum().print();
