import "./common.js";

let input = "d11.txt".readString().getWords();

(25).times(() => {
    input = input.flatMap((v) => {
        if (v === "0") return "1";
        if (v.length % 2 === 0) return [
            v.substring(0, v.length / 2),
            v.substring(v.length / 2, v.length),
        ]

        return (+v * 2024).toString();
    }).map(v => (+v).toString());
});

input.length.print();
