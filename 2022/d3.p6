open("d3.txt")
    .lines
    .map(*.comb)
    .rotor(3)
    .map({ [∩] $_ })
    .map({valueof(.keys[0])})
    .sum
    .say;

sub valueof($e) {
    given $e {
        when ("a" le $e le "z") { ord($e) - ord("a") + 1  }
        when ("A" le $e le "Z") { ord($e) - ord("A") + 27 }
    }
}
