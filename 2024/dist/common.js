import * as fs from "fs";
String.prototype.readStringGrid = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file.split(/[\r]?\n/g).map(s => s.split(""));
};
String.prototype.readNumsLines = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file.split(/[\r]?\n/g).map(s => s.split(/\s+/).map(Number));
};
String.prototype.readNums = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file.split(/\s+/).map(Number);
};
String.prototype.readString = function () {
    const file = fs.readFileSync(this, { encoding: 'utf-8' }).toString();
    return file;
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
Object.prototype.mapValues = function (mapper) {
    const newObject = {};
    Object.entries(this).forEach(([k, v]) => newObject[k] = mapper(v));
    return newObject;
};
Array.prototype.range = function () {
    return range(0, this.length - 1);
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
    console.table(this);
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
