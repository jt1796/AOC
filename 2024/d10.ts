import "./common.js";

const grid = "d10.txt".readStringGrid();

const trailheads = grid.gridSymbolMap()['0'];

function findTrails(x: number, y: number, target: number): number {
    const here = grid[x]?.[y];
    if (target !== +here) {
        return 0;
    }

    if (here === "9") {
        return 1;
    }

    return findTrails(x + 1, y, target + 1) 
        + findTrails(x - 1, y, target + 1)
        + findTrails(x, y - 1, target + 1)
        + findTrails(x, y + 1, target + 1);
}

trailheads.map(([x, y]) => findTrails(x, y, 0)).sum().print();
