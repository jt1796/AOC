import "./common.js";
const lines = "d7.txt".readNumsLines();
const check = (target, accum, nums) => {
    if (!nums.length) {
        return target === accum ? target : 0;
    }
    if (accum > target) {
        return 0;
    }
    const [next, ...rem] = nums;
    return check(target, accum + next, rem)
        || check(target, accum ? accum * next : 0, rem)
        || check(target, +(accum.toString() + next.toString()), rem);
};
lines.map(([res, ...nums]) => check(res, 0, nums)).sum().print();
