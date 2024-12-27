import { cross } from "./common.js";

const humanKeypad = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['', '0', 'A'],
];

const robotKeypad = [
    ['', '^', 'A'],
    ['<', 'v', '>'],
];

function computePathsForPad(keypad: string[][]) {
    const keypadBestPaths = new Map<string, string[]>();
    const keypadSymbolMap = keypad.gridSymbolMap();
    const symbolsCrossed = cross([keypad.flat(), keypad.flat()]);
    
    for (const [from, to] of symbolsCrossed) {
        const fromCoords = keypadSymbolMap[from][0];
        const toCoords = keypadSymbolMap[to][0];
        const [yDiff, xDiff] = toCoords.sub(fromCoords);
    
        const key = from + " to " + to;
        keypadBestPaths.set(key, []);
    
        const [toAvoidy, toAvoidx] = keypadSymbolMap[''][0];
    
        let pathA = '';
    
        if (toAvoidy !== fromCoords[0] || toAvoidx !== toCoords[1]) {
            xDiff.times(() => pathA += xDiff > 0 ? '>' : '<');
            yDiff.times(() => pathA += yDiff > 0 ? 'v' : '^');
            pathA += 'A';
        }
    
        let pathB = '';
        if (toAvoidx !== fromCoords[1] || toAvoidy !== toCoords[0]) {
            yDiff.times(() => pathB += yDiff > 0 ? 'v' : '^');
            xDiff.times(() => pathB += xDiff > 0 ? '>' : '<');
            pathB += 'A';
        }
        
        if (pathA !== '') {
            keypadBestPaths.get(key)?.push(pathA);
        }
        if (pathB !== '' && pathA !== pathB) {
            keypadBestPaths.get(key)?.push(pathB);
        }
    }

    return keypadBestPaths;
}

const humanKeypadBestPaths = computePathsForPad(humanKeypad);
const robotKeypadBestPaths = computePathsForPad(robotKeypad);

function replaceWithPresses(code: string, bestPaths: Map<string, string[]>) {
    code = 'A' + code;
    const input = code.split('').chunk(2, -1)
        .filter(l => l.length === 2)
        .map(([from, to]) => `${from} to ${to}`);
    return input.map(i => bestPaths.get(i)!);
}

function scoreWithCode(code: string) {
    let input = replaceWithPresses(code, humanKeypadBestPaths);
    2..times(() => {
        input = input.map(seq => 
            seq.flatMap(s => cross(replaceWithPresses(s, robotKeypadBestPaths))).map(a => a.join(''))
        );
    });
    
    const length = Object.values(input).map(l => l.map(l => l.length).sortAsNums()[0]).sum();
    const codeNum = +code.replace('A', '');

    return length * codeNum;
}

"d21.txt".readString().lines().map(l => scoreWithCode(l)).sum().print();
