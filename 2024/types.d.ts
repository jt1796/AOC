interface Array<T> {
    sum(): number;
    toMap(): Record<T, T>;
    chunk(size: number, skip?: number, start?: number): Array<T>;
    sortAsNums(): Array<T>;
    groupBy(keyfn: (t: T) => string): Record<string, T[]>;
    spliced(start: number, deleteCount = 0, ...toAdd: T[] = []): Array<T>;
    range(): number[];
    print(): Array<T>;
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
    readStringGrid(): string[][];
    print(): String;
}

interface Number {
    print(): Number;
}