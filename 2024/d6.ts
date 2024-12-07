import "./common.js";
import { range } from "./common.js";

const proto = "d6.txt".readStringGrid();
range(0, proto.length - 1).map(y => {
    return range(0, proto[0].length - 1).map(x => {
        return checkLoop(x, y);
    }).sum();
}).sum().print();

function checkLoop(x: number, y: number) {
    const moveMap: Record<string, number[]> = {
        '^': [-1, 0],
        '>': [0, 1],
        '<': [0, -1],
        'v': [1, 0],
    };
    
    const next: Record<string, string> = {
        '^': '>',
        '>': 'v',
        'v': '<',
        '<': '^',
    };

    const grid = "d6.txt".readStringGrid();

    let dir = '^';
    let coords = grid.gridFind(dir);

    if ([x, y].join(',') !== coords.join(',')) {
        grid.gridSet([x, y], '#');
    }

    const seen = new Set<string>();
    
    while(grid.gridIndex(coords)) {
        console.log
        if (seen.has(coords.join(',') + dir)) {
            return true;
        }
        seen.add(coords.join(',') + dir);
    
        const possibleNextCoords = coords.add(moveMap[dir]);
        if (grid.gridIndex(possibleNextCoords) === '#') {
            dir = next[dir];
        } else {
            grid.gridSet(coords, '.');
            coords = possibleNextCoords;
        }
    
        grid.gridSet(coords, dir);
    }
    
    return false;
}

