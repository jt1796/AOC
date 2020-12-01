sub are-equal(@nums) {
    [==] @nums
}

sub ascending(@nums) {
    [<=] @nums
}

sub test-number($num) {
    return False unless (m:g/((.)$0*)/.first({ .Str.chars eq 2 }) with $num);
    my @pairs = ((Nil, |$num.split('')) Z $num.split(''))[2..*-2];
    so (ascending(@pairs.all) and are-equal(@pairs.any));
}

(136818..685979).grep({ test-number $_ }).elems.say;
