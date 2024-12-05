import "./common.js";
const grid = "d4.txt".readStringGrid();
const dirsA = [[-1, -1], [0, 0], [1, 1]];
const dirsB = [[-1, 1], [0, 0], [1, -1]];
grid.flatMap((row, x) => row.flatMap((i, y) => [dirsA, dirsB].every(dir => dir.map(([dx, dy]) => { var _a; return (_a = grid[x + dx]) === null || _a === void 0 ? void 0 : _a[y + dy]; }).join('') in { 'MAS': 1, 'SAM': 1 }))).sum().print();
