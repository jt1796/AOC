say .<forward> * (.<down> - .<up>) with "d2.txt".IO.words.rotor(2).map({ [xx] $_ }).Slip.Bag;

say .[1] * .[2] with reduce(-> @l, $b { @l >>+<< (given $b {
    when 'forward' { (0,  1, @l[0]) }
    when 'up'      { (1,  0,    0 ) }
    when 'down'    { (-1, 0,    0,) }
}) }, (0, 0, 0), "d2.txt".IO.words.rotor(2).map({ [xx] $_ }).flat.Slip);