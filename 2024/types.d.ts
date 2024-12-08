interface Array<T> {
    sum(): number;
    toMap(): Record<T, T>;
    chunk(size: number, skip?: number, start?: number): Array<T>;
    sortAsNums(): Array<T>;
    groupBy(keyfn: (t: T) => string): Record<string, T[]>;
    spliced(start: number, deleteCount = 0, ...toAdd: T[] = []): Array<T>;
    range(): number[];
    pairs(): T[][];
    print(): Array<T>;
    printGrid(): Array<T>;
    gridFind(x: any): number[];
    gridIndex(x: number[]): string;
    gridSet(coords: number[], val: any): Array<T>;
    gridSymbolMap(): Record<string, number[][]>;
    add(arr: T[]): T[];
    sub(arr: T[]): T[];
}

interface Object {
    toList(): Array;
    mapValues(mapper: (t: T) => V): Record<string, V>;
    print(): Object;
}

interface String {
    readNumsLines(): number[][];
    readNums(): number[]; 
    readString(): string;
    lines(): string[];
    getNums(): number[];
    getWords(): string[];
    readStringGrid(): string[][];
    print(): String;
}

interface Number {
    print(): Number;
}
