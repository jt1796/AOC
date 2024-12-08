import * as fs from "fs";
String.prototype.readStringGrid = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file.split(/[\r]?\n/g).map(s => s.split(""));
};
String.prototype.readNumsLines = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file.split(/[\r]?\n/g).map(s => s.getNums());
};
String.prototype.readNums = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file.split(/\s+/).map(Number);
};
String.prototype.readString = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file;
};
String.prototype.lines = function () {
    return this.split(/[\r]?\n/g).map(l => l.trim());
};
String.prototype.getNums = function () {
    const num = /\d+/g;
    const str = this.toString();
    return exhaust(() => num.exec(str)).map(s => +s);
};
String.prototype.getWords = function () {
    const num = /\w+/g;
    const str = this.toString();
    return exhaust(() => num.exec(str)).map(s => s.toString());
};
Array.prototype.chunk = function (size, skip = 0, start = 0) {
    const chunks = [];
    let curChunk = [];
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
};
Array.prototype.sortAsNums = function () {
    const newArr = [...this];
    newArr.sort(function (a, b) { return a - b; });
    return newArr;
};
Array.prototype.sum = function () {
    let accum = 0;
    for (let i = 0; i < this.length; i++) {
        accum += this[i];
    }
    return accum;
};
Array.prototype.toMap = function () {
    const accum = {};
    for (let i = 0; i < this.length; i += 2) {
        accum[this[i]] = this[i + 1];
    }
    return accum;
};
Array.prototype.groupBy = function (keyfn) {
    const grouped = {};
    for (let i = 0; i < this.length; i++) {
        const key = keyfn(this[i]);
        if (!grouped[key]) {
            grouped[key] = [];
        }
        grouped[key].push(this[i]);
    }
    return grouped;
};
Array.prototype.spliced = function (start, deleteCount = 0, ...toAddd) {
    const copy = [...this];
    copy.splice(start, deleteCount, ...toAddd);
    return copy;
};
Array.prototype.printGrid = function () {
    this.forEach((row) => {
        row.join('').print();
    });
    return this;
};
Array.prototype.gridFind = function (x) {
    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this[i].length; j++) {
            if (this[i][j] === x) {
                return [i, j];
            }
        }
    }
    return [-1, -1];
};
Array.prototype.gridSymbolMap = function () {
    const res = {};
    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this[i].length; j++) {
            const symbol = this[i][j];
            res[symbol] = res[symbol] || [];
            res[symbol].push([i, j]);
        }
    }
    return res;
};
Array.prototype.gridIndex = function ([x, y]) {
    var _a;
    return (_a = this[x]) === null || _a === void 0 ? void 0 : _a[y];
};
Array.prototype.gridSet = function ([x, y], val) {
    if (x >= 0 && y >= 0 && x < this.length && y < this[x].length) {
        this[x][y] = val;
    }
    return this;
};
Array.prototype.add = function (arr) {
    const newArr = [];
    this.forEach((val, idx) => {
        newArr[idx] = val + arr[idx];
    });
    return newArr;
};
Array.prototype.sub = function (arr) {
    const newArr = [];
    this.forEach((val, idx) => {
        newArr[idx] = val - arr[idx];
    });
    return newArr;
};
Object.prototype.mapValues = function (mapper) {
    const newObject = {};
    Object.entries(this).forEach(([k, v]) => newObject[k] = mapper(v));
    return newObject;
};
Array.prototype.pairs = function () {
    const pairs = [];
    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this.length; j++) {
            if (i !== j) {
                pairs.push([this[i], this[j]]);
            }
        }
    }
    return pairs;
};
Array.prototype.range = function () {
    return range(0, this.length - 1);
};
Object.prototype.print = function () {
    console.log(this);
    return this;
};
String.prototype.print = function () {
    console.log(this);
    return this;
};
Number.prototype.print = function () {
    console.log(this);
    return this;
};
Array.prototype.print = function () {
    console.log(this);
    return this;
};
export const zip = (listA, listB) => {
    const minLength = Math.min(listA.length, listB.length);
    const zipped = [];
    for (let i = 0; i < minLength; i++) {
        zipped.push([
            listA[i],
            listB[i],
        ]);
    }
    return zipped;
};
export const range = (start, end, step = 1) => {
    const res = [];
    for (let i = start; i <= end; i += step) {
        res.push(i);
    }
    return res;
};
export const exhaust = (fn) => {
    const results = [];
    let result = undefined;
    while (result = fn()) {
        results.push(result);
    }
    return results;
};
export const cross = (arrs) => {
    if (arrs.length === 0)
        return [];
    if (arrs.length === 1)
        return arrs[0].map(i => [i]);
    const [head, ...tail] = arrs;
    const recurse = cross(tail);
    return head.flatMap(i => recurse.map(j => [i, ...j]));
};
export const makeGraph = (edges) => {
    const graph = {};
    edges.forEach(([from, to]) => {
        graph[from] = graph[from] || [];
        graph[to] = graph[to] || [];
        graph[from].push(to);
    });
    return graph;
};
export const search = (graph, start) => {
    let frontier = [start];
    const seen = new Set();
    while (frontier.length) {
        frontier.forEach(s => seen.add(s));
        frontier = frontier.flatMap(v => graph[v]).filter(v => !seen.has(v));
    }
    return [...seen];
};
