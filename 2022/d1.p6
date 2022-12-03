sub next { $^b ?? $^a + $^b !! 0 }
say .max with [\[&next]] open('d1.txt').lines;