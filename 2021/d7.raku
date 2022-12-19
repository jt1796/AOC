my @nums = "d7.txt".IO.comb(/\d+/)>>.Int;
my @cost = [\+] 0, 1, 2 ... ∞;

say ^@nums.max .map({ [+] @cost[$_.>>.abs] with @nums <<->> $_ }).min;