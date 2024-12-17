import { memo } from "./common.js";

let input = "d11.txt".readString().getWords();

const next = memo((num: string, level: number): number => {
    if (level === 75) {
        return 1;
    }

    if (num === "0") {
        return next("1", level + 1);
    }

    if (num.length % 2 === 0) {
        return  next((+num.substring(0, num.length / 2)).toString(), level + 1) 
        + next((+num.substring(num.length / 2, num.length)).toString(), level + 1);
    }

    return next((+num * 2024).toString(), level + 1);
});

input.map(v => next(v, 0)).sum().print();
