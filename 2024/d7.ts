import "./common.js";

const lines = "d7.txt".readNumsLines();

const check = (target: number, accum: number, nums: number[]): boolean => {
    if (!nums.length) {
        return target === accum;
    }

    if (accum > target) {
        return false;
    }

    const [next, ...rem] = nums;

    return check(target, accum + next, rem) 
        || check(target, accum ? accum * next : 0, rem)
        || check(target, +(accum.toString() + next.toString()), rem);
};

lines.map(([res, ...nums]) => {
    const valid = check(res, 0, nums);

    return valid ? res : 0;
}).sum().print();
