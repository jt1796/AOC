my @lines = open("d10.txt").lines.map({ /addx (.+)/ ?? |(0, $/[0]) !! 0 });
my @history = [\+] 1, |@lines;
my @ticks = .map({ ('.', '#')[.abs <= 1] }) with @history [Z-] (^∞).map(* % 40);

.say for @ticks.rotor(40)>>.join;
