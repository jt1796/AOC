import "./common.js";

const pairs = "d9.txt".readString().split('').map(Number).chunk(2);

const disk = pairs.flatMap(([f, b], fileNo) => 
    Array(f).fill(fileNo).concat(Array(b || 0).fill(-1)) as number[]
);

for (let i = disk.length - 1; i >= 0; i--) {
    if (disk[i] !== -1) {
        const nextFreeSpace = disk.findIndex((v) => v === -1);
        if (nextFreeSpace > i) break;
        disk[nextFreeSpace] = disk[i];
        disk[i] = -1;
    }
}

disk.filter(v => v !== -1).map((v, i) => v * i).sum().print();
