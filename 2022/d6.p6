say open('d6.txt').comb.rotor(14 => -13).first({$_.unique == $_}, :k) + 14;