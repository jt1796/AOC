import { cross, flipflop, makeGraph, range, search, zip } from "./common";

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

    it("ranges negative", () => {
        const result = range(10, 4, 2);

        expect(result).toEqual([10, 8, 6, 4]);
    });
});

describe("Object", () => {
    it("maps values", () => {
        const o = {'a': 3, 'b': 8};
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

        expect(result).toEqual([9, 2, 3])
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

describe("cross", () => {
    it("works with empty input", () => {
        expect(cross([])).toEqual([]);
        expect(cross([[]])).toEqual([]);
        expect(cross([[], []])).toEqual([]);
    });

    it("works with one array", () => {
        expect(cross([[1, 2, 3]])).toEqual([[1], [2], [3]]);
    });

    it("works with a pair of arrays", () => {
        expect(cross([[1, 2], [3, 4]])).toEqual([
            [1, 3],
            [1, 4],
            [2, 3],
            [2, 4],
        ]);
    });

    it("works with three arrays", () => {
        expect(cross([[1, 2], [3, 4], [5, 6]])).toEqual([
            [1, 3, 5],
            [1, 3, 6],
            [1, 4, 5],
            [1, 4, 6],
            [2, 3, 5],
            [2, 3, 6],
            [2, 4, 5],
            [2, 4, 6],
        ]);
    });
});

describe("string lines", () => {
    it("gets lines", () => {
        const str = `hello
        
        there` + "\r\n" + "bye";

        expect(str.lines()).toEqual(["hello", "", "there", "bye"]);
    });
});

describe("string nums", () => {
    it("gets nums", () => {
        const str = `123
        456 45
        3,5|7`;

        expect(str.getNums()).toEqual([123, 456, 45, 3, 5, 7]);
    });
});

describe("string words", () => {
    it("gets words", () => {
        const str = `blah12
        456 45
        3,5|7`;

        expect(str.getWords()).toEqual(["blah12", "456", "45", "3", "5", "7"]);
    });
});

describe("graphs", () => {
    it("makes them", () => {
        const edges = [['1', '2'], ['1', '3'], ['3', '5'], ['10', '11']];
        expect(makeGraph(edges)).toEqual({
            "1": ["2", "3"],
            "2": [],
            "3": ["5"],
            "5": [],
            "10": ["11"],
            "11": [],
        });
    });

    it ("searches them", () => {
        const graph = makeGraph([
            ['1', '2'],
            ['2', '3'],
            ['2', '4'],
            ['4', '5'],
            ['6', '7'],
            ['7', '8'],
        ]);

        expect(search(graph, '1')).toEqual([
            '1', '2', '3', '4', '5'
        ]);
    });
});

describe("grid find", () => {
    it("gives coordinates when found", () => {
        const grid = `....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
        `.lines().map(l => l.split(''));
        
        expect(grid.gridFind('^')).toEqual([6, 4]);
        expect(grid.gridFind('v')).toEqual([-1, -1]);
        expect(grid.gridIndex([6, 4])).toEqual('^');
    });
});

describe("grid  neighbors", () => {
    it("gives neighbors", () => {
        const grid = `123
456
789`.lines().map(l => l.split(''));
    
            expect(grid.gridNeighbors([1, 1])).toEqual([
                "6", "8", "4", "2"
            ]);
            
            expect(grid.gridNeighbors([0, 0])).toEqual([
                "2", "4", undefined, undefined
            ]);

            expect(grid.gridNeighbors([2, 2])).toEqual([
                undefined, undefined, "8", "6"
            ]);
        });
});

describe("list add", () => {
    it("adds numbers", () => {
        expect([1, 2, 3].add([4, 5, 6])).toEqual([5, 7, 9]);
    });

    it("adds strings", () => {
        expect(["cat", "dog"].add([" foo", " bar"])).toEqual(["cat foo", "dog bar"]);
    });
});

describe("grid symbol map", () => {
    it("maps symbols to coordinates", () => {
        const grid = `...
.%.
a..`.lines().map(l => l.split(''));

        expect(grid.gridSymbolMap()).toEqual({
            '.': [[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 1], [2, 2]],
            '%': [[1, 1]],
            'a': [[2, 0]],
        });
    });
});

describe("array pairs", () => {
    it("pairs", () => {
        const a = [1, 2, 3];

        expect(a.pairs()).toEqual([
            [1, 2],
            [1, 3],
            [2, 1],
            [2, 3],
            [3, 1],
            [3, 2],
        ]);
    });
});

describe("flipflop", () => {
    it("alternates when initially false", () => {
        const arr = [1, 1, -1, -1, 2, 2, -1];
        const res = flipflop(arr, (e) => e === -1);

        expect(res).toEqual([2, 4, 6, 7]);
    });

    it("alternates when initially true", () => {
        const arr = [1, 1, -1, -1, 2, 2, -1];
        const res = flipflop(arr, (e) => e !== -1);

        expect(res).toEqual([0, 2, 4, 6]);
    });
});