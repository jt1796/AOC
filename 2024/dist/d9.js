import "./common.js";
import { flipflop } from "./common.js";
const pairs = "d9.txt".readString().split('').map(Number).chunk(2);
const disk = pairs.flatMap(([f, b], fileNo) => Array(f).fill(fileNo).concat(Array(b || 0).fill(-1)));
const holes = flipflop(disk, (e) => e === -1).chunk(2).map(c => [c[0], c[1] - c[0]]);
for (let i = disk.length - 1; i >= 0; i--) {
    if (disk[i] !== -1) {
        const fileNo = disk[i];
        const firstIndex = disk.findIndex((e) => e === fileNo);
        const length = i - firstIndex + 1;
        const gap = holes.find(h => h[1] >= length && h[0] < i);
        if (gap) {
            for (let i = 0; i < length; i++) {
                disk[firstIndex + i] = -1;
                disk[gap[0] + i] = fileNo;
            }
            gap[0] = gap[0] + length;
            gap[1] = gap[1] - length;
        }
        i = firstIndex;
    }
}
disk.map((v, i) => v === -1 ? 0 : v * i).sum().print();
