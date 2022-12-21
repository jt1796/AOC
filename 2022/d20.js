const { readFileSync } = require("fs");
const input = readFileSync('./d20.txt').toString().split('\n').map(Number).map((v) => 811589153 * v);

const linkedListNodes = input.map(i => ({ val: i, next: null, prev: null }));
linkedListNodes.forEach((n, i) => n.next = linkedListNodes[(i + 1) % linkedListNodes.length]);
linkedListNodes.forEach((n, i) => n.prev = linkedListNodes[(i - 1 + linkedListNodes.length) % linkedListNodes.length]);

const print = () => {
    let str = "";
    let ptr = linkedListNodes[0];
    linkedListNodes.forEach(() => {
        str += ` ${ptr.val}`;
        ptr = ptr.next;
    });
    console.log(str);
}

for (let i = 0; i < 10; i++) {
    linkedListNodes.forEach(node => {
        // extract node and move it up or down
        //    left     node       right
        let left = node.prev;
        let right = node.next;
    
        left.next = right;
        right.prev = left;
    
        // insert
        let targetCount = (node.val % (linkedListNodes.length - 1));

        if (targetCount < 0) {
            while (targetCount++) left = left.prev;
        } else {
            while (targetCount--) left = left.next;
        }
        right = left.next;
    
        left.next = node;
        node.next = right;
        node.prev = left;
        right.prev = node;
        // print();
    });
    console.log('---')
}

// find the zero.
let zeroNode = linkedListNodes.find(n => n.val === 0);
let sum = 0;
for (let i = 0; i <= 3000; i++) {
    if (i === 1000 || i === 2000 || i === 3000) {
        console.log(zeroNode.val);
        sum += zeroNode.val;
    }
    zeroNode = zeroNode.next;
}

console.log(sum);

// -18746 not the right answer
// 6440 too low