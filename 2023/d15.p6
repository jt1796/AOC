"d15.txt".IO.slurp.split(",").map({ (0, |$_.comb>>.ord).reduce({ 17 * ($^a + $^b) mod 256 }) }).sum.say;
