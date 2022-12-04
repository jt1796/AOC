say [+] open("d4.txt").lines>>.comb(/\d+/)
    .map({ sub (@j){ [<=] @j }(.[0,2|3,1]) });
