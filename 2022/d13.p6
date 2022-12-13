use MONKEY-SEE-NO-EVAL;

my @lists = open('d13.txt').split(/\n\n/)>>.lines.deepmap: *.subst("10", "'a'", :g).subst("[", "[0,", :g);

say [+] 1..Inf Z* @lists.map({ [lt] $_>>.&EVAL });


# 5594 too low
# 6318 too high
# 6006 too low