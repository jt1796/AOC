import * as fs from "fs";

String.prototype.readStringGrid = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file.split(/[\r]?\n/g).map(s => s.split(""));
}

String.prototype.readNumsLines = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file.split(/[\r]?\n/g).map(s => s.getNums());
}

String.prototype.readNums = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file.split(/\s+/).map(Number);
}

String.prototype.readString = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file;
}

String.prototype.lines = function() {
    return this.split(/[\r]?\n/g).map(l => l.trim());
}

String.prototype.getNums = function() {
    const num = /\d+/g;
    const str = this.toString();
    return exhaust(() => num.exec(str)).map(s => +s);
}

String.prototype.getWords = function() {
    const num = /\w+/g;
    const str = this.toString();
    return exhaust(() => num.exec(str)).map(s => s.toString());
}

Array.prototype.chunk = function<T>(size: number, skip = 0, start = 0) {
    const chunks: T[][] = [];
    let curChunk : T[] = [];

    let idx = start;
    while (true) {
        if (curChunk.length) {
            chunks.push(curChunk);
        }
        curChunk = [];

        for (let i = 0; i < size; i++) {
            if (idx + i >= this.length) {
                if (curChunk.length) {
                    chunks.push(curChunk);
                }
                return chunks;
            }
            curChunk.push(this[idx + i]);
        }
        idx += size + skip;
    }
}

Array.prototype.sortAsNums = function() {
    const newArr = [...this];
    newArr.sort(function (a, b) {  return a - b;  });

    return newArr;
}

Array.prototype.sum = function() {
    let accum = 0;
    for (let i = 0; i < this.length; i++) {
        accum += this[i];
    }

    return accum;
}

Array.prototype.toMap = function<T>() {
    const accum: Record<string, T> = {};
    for (let i = 0; i < this.length; i += 2) {
        accum[this[i]] = this[i + 1];
    }

    return accum
}

Array.prototype.groupBy = function<T>(keyfn: (t: T) => string) {
    const grouped: Record<string, T[]> = {};
    for (let i = 0; i < this.length; i++) {
        const key = keyfn(this[i]);
        if (!grouped[key]) {
            grouped[key] = [];
        }

        grouped[key].push(this[i]);
    }

    return grouped;
}

Array.prototype.spliced = function(start: number, deleteCount = 0, ...toAddd) {
    const copy = [...this];
    copy.splice(start, deleteCount, ...toAddd);

    return copy;
}

Array.prototype.printGrid = function() {
    this.forEach((row) => {
        row.join('').print();
    });

    return this;
}

Array.prototype.gridNeighbors = function([x, y]) {
    const neighbors = [];
    const dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]];
    for (const [dx, dy] of dirs) {
        const [nx, ny] = [x + dx, y + dy];
        if (nx >= 0 && ny >= 0 && nx < this.length && ny < this[nx].length) {
            neighbors.push(this.gridIndex([nx, ny]));
        } else {
            neighbors.push(undefined);
        }
    }

    return neighbors;
}

Array.prototype.gridFind = function(x: any) {
    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this[i].length; j++) {
            if (this[i][j] === x) {
                return [i, j];
            }
        }
    }

    return [-1, -1];
}

Array.prototype.gridSymbolMap = function() {
    const res: Record<string, number[][]> = {};
    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this[i].length; j++) {
            const symbol = this[i][j];
            res[symbol] = res[symbol] || [];
            res[symbol].push([i, j]);
        }
    }

    return res;
}

Array.prototype.gridIndex = function([x, y]) {
    return this[x]?.[y];
}

Array.prototype.gridSet = function([x, y], val) {
    if (x >= 0 && y >= 0 && x < this.length && y < this[x].length) {
        this[x][y] = val;
    }

    return this;
}

Array.prototype.add = function<T>(arr: T[]) {
    const newArr: T[] = [];
    this.forEach((val, idx) => {
        newArr[idx] = val + arr[idx];
    });

    return newArr;
}

Array.prototype.sub = function(arr: number[]) {
    const newArr: number[] = [];
    this.forEach((val, idx) => {
        newArr[idx] = val - arr[idx];
    });

    return newArr;
}

Object.prototype.mapValues = function<T, V>(mapper: (t: T) => V) {
    const newObject: Record<string, V> = {};

    Object.entries(this).forEach(([k, v]) => newObject[k] = mapper(v));

    return newObject;
}

Array.prototype.pairs = function<T>() {
    const pairs: T[][] = [];

    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this.length; j++) {
            if (i !== j) {
                pairs.push([this[i], this[j]]);
            }
        }
    }

    return pairs;
}

Array.prototype.range = function() {
    return range(0, this.length - 1);
}

Array.prototype.unique = function<T>() {
    const set = new Set<T>();
    this.forEach(v => set.add(v));

    return [...set];
}

Object.prototype.print = function() {
    console.log(this);

    return this;
}

String.prototype.print = function() {
    console.log(this);

    return this;
}

Number.prototype.print = function() {
    console.log(this);

    return this;
}

Number.prototype.times = function(fn: (i: number) => void) {
    if (this === 0) return;
    for (const i of range(0, +this - (+this > 0 ? 1 : -1))) {
        fn(i);
    }
}

Array.prototype.print = function() {
    console.log(this);

    return this;
}

export const zip = <T, B>(listA: T[], listB: B[]) => {
    const minLength = Math.min(listA.length, listB.length);
    const zipped: [T, B][] = [];
    for (let i = 0; i < minLength; i++) {
        zipped.push([
            listA[i],
            listB[i],
        ]);
    }

    return zipped;
}

export const range = (start: number, end: number, step = 1) => {
    const res: number[] = [];
    if (end > start) {
        for (let i = start; i <= end; i += step) {
            res.push(i);
        }
    } else {
        for (let i = start; i >= end; i += -step) {
            res.push(i);
        }
    }


    return res;
}

export const exhaust = <T>(fn: () => T | undefined) => {
    const results = [];
    let result = undefined;
    while (result = fn()) {
        results.push(result);
    }

    return results;
}

export const cross = <T>(arrs: T[][]): T[][] => {
    if (arrs.length === 0) return [];
    if (arrs.length === 1) return arrs[0].map(i => [i]);

    const [head, ...tail] = arrs;
    const recurse = cross(tail);

    return head.flatMap(i => recurse.map(j => [i, ...j]));
}

export const makeGraph = (edges: string[][]) => {
    const graph: Record<string, string[]> = {};
    edges.forEach(([from, to]) => {
        graph[from] = graph[from] || [];
        graph[to] = graph[to] || [];

        graph[from].push(to);
    });

    return graph;
};

export const search = (graph: Record<string, string[]>, start: string) => {
    let frontier = [start];
    const seen: Set<string> = new Set();
    while (frontier.length) {
        frontier.forEach(s => seen.add(s));
        frontier = frontier.flatMap(v => graph[v]).filter(v => !seen.has(v));
    }

    return [...seen];
}

export const flipflop = <T>(arr: T[], pred: (t: T) => boolean) => {
    let on = false;
    const indices: number[] = [];
    arr.forEach((e, idx) => {
        const now = pred(e);
        if (on !== now) {
            indices.push(idx);
        }
        on = now;
    });

    if (on) {
        indices.push(arr.length);
    }

    return indices;
}

export const memo = <T extends Function>(fn: T): T => {
    const cache: any = {};

    const fn2: any = (...args: any[]) => {
        const cacheKey = JSON.stringify(args);
        if (cache[cacheKey]) {
            return cache[cacheKey];
        }

        cache[cacheKey] = fn(...args);

        return cache[cacheKey];
    };

    return fn2;
};