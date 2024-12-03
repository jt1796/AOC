import { range, zip } from "./common";
describe("zip", () => {
    it("zips", () => {
        const a = [1, 2, 3];
        const b = ['a', 'b', 'c', 'd'];
        const result = zip(a, b);
        expect(result).toEqual([[1, 'a'], [2, 'b'], [3, 'c']]);
    });
});
describe("range", () => {
    it("ranges", () => {
        const result = range(1, 7, 2);
        expect(result).toEqual([1, 3, 5, 7]);
    });
});
describe("Object", () => {
    it("maps values", () => {
        const o = { 'a': 3, 'b': 8 };
        const result = o.mapValues((v) => 2 * v);
        expect(result).toEqual({ 'a': 6, 'b': 16 });
    });
});
describe("Array", () => {
    it("ranges", () => {
        const arr = [0, 0, 0];
        expect(arr.range()).toEqual([0, 1, 2]);
    });
    it("splices", () => {
        const arr = [1, 2, 3];
        const result = arr.spliced(0, 1, 9);
        expect(result).toEqual([9, 2, 3]);
        expect(arr).toEqual([1, 2, 3]);
    });
    it("groups", () => {
        const arr = [
            { animal: "dog", age: 7 },
            { animal: "cat", age: 3 },
            { animal: "dog", age: 1 },
        ];
        const result = arr.groupBy((a) => a.animal);
        expect(result).toEqual({
            'dog': [arr[0], arr[2]],
            'cat': [arr[1]],
        });
    });
    it("sorts", () => {
        const arr = [9, 101, 8];
        const result = arr.sortAsNums();
        expect(result).toEqual([8, 9, 101]);
    });
    it("chunks", () => {
        const arr = range(0, 10);
        expect(arr.chunk(3, 0, 0)).toEqual([[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10]]);
        expect(arr.chunk(3, 1, 0)).toEqual([[0, 1, 2], [4, 5, 6], [8, 9, 10]]);
        expect(arr.chunk(3, 1, 1)).toEqual([[1, 2, 3], [5, 6, 7], [9, 10]]);
        const evenAligned = range(0, 8);
        expect(evenAligned.chunk(3)).toEqual([[0, 1, 2], [3, 4, 5], [6, 7, 8]]);
    });
});
