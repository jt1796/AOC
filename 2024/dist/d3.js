import { exhaust } from "./common.js";
const input = "d3.txt".readString().replace(/don't\(\).*?do\(\)/sg, '');
const mul = /mul\((\d+),(\d+)\)/g;
const res = exhaust(() => mul.exec(input)).map(m => +m[1] * +m[2]).sum();
console.log({ res });
