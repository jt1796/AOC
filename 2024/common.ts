import * as fs from "fs";

String.prototype.readStringGrid = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file.split(/[\r]?\n/g).map(s => s.split(""));
}

String.prototype.readNumsLines = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file.split(/[\r]?\n/g).map(s => s.split(/\s+/).map(Number));
}

String.prototype.readNums = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file.split(/\s+/).map(Number);
}

String.prototype.readString = function() {
    const file = fs.readFileSync(this as string, { encoding: 'utf-8' }).toString();

    return file;
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

Object.prototype.mapValues = function<T, V>(mapper: (t: T) => V) {
    const newObject: Record<string, V> = {};

    Object.entries(this).forEach(([k, v]) => newObject[k] = mapper(v));

    return newObject;
}

Array.prototype.range = function() {
    return range(0, this.length - 1);
}

String.prototype.print = function() {
    console.log(this);

    return this;
}

Number.prototype.print = function() {
    console.log(this);

    return this;
}

Array.prototype.print = function() {
    console.table(this);

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
    for (let i = start; i <= end; i += step) {
        res.push(i);
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
