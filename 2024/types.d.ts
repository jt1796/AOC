interface Array<T> {
    sum(): number;
    toMap(): Record<T, T>;
    chunk(size: number, skip?: number, start?: number): Array<T>;
    sortAsNums(): Array<T>;
    groupBy(keyfn: (t: T) => string): Record<string, T[]>;
    spliced(start: number, deleteCount = 0, ...toAdd: T[] = []): Array<T>;
}

interface Object {
    toList(): Array;
    mapValues(mapper: (t: T) => V): Record<string, V>;
}

interface String {
    readNumsLines(): number[][];
    readNums(): number[]; 
}
