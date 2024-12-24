import "./common.js";

const keypad = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['', '0', 'A'],
];

const controlPad = [
    ['', '^', 'A'],
    ['<', 'v', '>'],
];

class Layer {
    x: number;
    y: number;
    pad: string[][];
    lowerLayer?: Layer;
    buttonsPressed: string;
    clicks: number;

    constructor(pad: string[][], x: number, y: number, buttonsPressed: string, clicks: number, lowerLayer?: Layer) {
        this.pad = pad;
        this.x = x;
        this.y = y;
        this.lowerLayer = lowerLayer;
        this.buttonsPressed = buttonsPressed;
        this.clicks = clicks;
    }

    getButtonsPressed(): string {
        if (this.lowerLayer) {
            return this.lowerLayer.getButtonsPressed();
        }
        return this.buttonsPressed;
    }

    check() {
        if (!this.pad[this.y]?.[this.x]) {
            throw new Error('out of bounds');
        }
        if (this.lowerLayer) {
            this.lowerLayer.check();
        }
    }

    clone(): Layer {
        if (!this.lowerLayer) {
            return new Layer(this.pad, this.x, this.y, this.buttonsPressed, this.clicks);
        }
        const clonedLowerLayer = this.lowerLayer.clone();
        return new Layer(this.pad, this.x, this.y, this.buttonsPressed, this.clicks, clonedLowerLayer);
    }

    print() {
        console.log(this.getStateString() + " -- " + this.clicks);
    }

    press(): Layer {
        this.clicks++;
        const button = this.pad[this.y]?.[this.x];
        if (!this.lowerLayer) {
            this.buttonsPressed = this.buttonsPressed + button;
            return this;
        }
        if (button === 'A') {
            this.lowerLayer.press();
        }
        if (button === '<') {
            this.lowerLayer.x--;
        }
        if (button === '>') {
            this.lowerLayer.x++;
        }
        if (button === '^') {
            this.lowerLayer.y--;
        }
        if (button === 'v') {
            this.lowerLayer.y++;
        }

        this.check();

        return this;
    }

    getStateString() {
        let base = '';
        if (this.lowerLayer) {
            base += this.lowerLayer.getStateString() + "/";
        }

        base += this.buttonsPressed + "_" + this.pad[this.y]?.[this.x];

        return base;
    }
}

const bottomLayer = new Layer(keypad, 2, 3, '', 0, undefined);
// let middleLayer = bottomLayer;
// (2).times(() => {
//     middleLayer
// });
const middleLayer1 = new Layer(controlPad, 2, 0, '', 0, bottomLayer);
const middleLayer2 = new Layer(controlPad, 2, 0, '', 0, middleLayer1);
const topLayer = new Layer(controlPad, 2, 0, '', 0, middleLayer2);

const possibleMoves = [
    [1, 0],
    [2, 0],
    [0, 1],
    [1, 1],
    [2, 1],
];


const calcForCode = (code: string) => {
    const cacheMap = new Map<string, number>();
    const frontier = [topLayer];
    while (frontier.length) {
        const current = frontier.shift()!;
    
        if (cacheMap.has(current.getStateString()) && cacheMap.get(current.getStateString())! <= current.clicks) {
            continue;
        } else {
            cacheMap.set(current.getStateString(), current.clicks);
        }
    
        if (!code.startsWith(current.getButtonsPressed())) {
            continue;
        }
    
        for (const move of possibleMoves) {
            const newLayer = current.clone();
            newLayer.x = move[0];
            newLayer.y = move[1];
            try {
                newLayer.press();
                frontier.push(newLayer);
            } catch (e) {}
        }
    }
    const min = Math.min(...[...cacheMap.entries()]
        .filter(([key]) => key.startsWith(code + "_"))
        .map(([_, value]) => value));
    const num = +(code.match(/\d+/g)?.join("")!);
        
    return min * num;
}

const codesFromFile = "d21.txt".readString().lines();

const codes = ["029A", "980A", "179A", "456A", "379A"];

console.log({ codesFromFile });
codesFromFile.map(code => calcForCode(code)).sum().print();


// 25 intermediate robots
// correct 278568