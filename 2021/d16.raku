my $trans = "d16.txt".IO.lines[0].comb.map({ conv($_).Slip }).Array;

sub conv($d) {
    my $bin = $d.parse-base(16).base(2).comb;
    return |("0" xx (4 - +$bin)) , |$bin;
}

sub parse-pkt($trans is rw) {
    my $ver = .parse-base(2).base(10) with [~] $trans[^3];
    $trans = $trans.splice(3);
    my $type = .parse-base(2).base(10) with [~] $trans[^3];
    $trans = $trans.splice(3);
    if ($type eq 4) {
        return parse-lit($trans).Int;
    } else {
        my $vals = parse-operator($trans);
        say $vals, ' ', $type;
        return [+] $vals.list if $type eq 0;
        return [*] $vals.list if $type eq 1;
        return $vals.min if $type eq 2;
        return $vals.max if $type eq 3;
        return (.Int with [>] $vals.list) if $type eq 5;
        return (.Int with [<] $vals.list) if $type eq 6;
        return (.Int with [eq] $vals.list) if $type eq 7;
    }
}

sub parse-operator($trans is rw) {
    my $lid = $trans.shift;
    my $vals = [];
    if ($lid eq '0') {
        my $len = .parse-base(2).base(10) with [~] $trans[^15];
        $trans = $trans.splice(15);
        my $origLen = +$trans;
        while ($origLen - +$trans ne $len) {
            $vals.push(parse-pkt($trans));
        }
    } else {        
        my $len = .parse-base(2).base(10) with [~] $trans[^11];
        $trans = $trans.splice(11);

        for ^$len {
            $vals.push(parse-pkt($trans));
        }
    }    
    return $vals;
}

sub parse-lit($trans is rw) {
    my $lit = [];
    my $contbit;
    repeat {
        $contbit = $trans.shift;
        my $lead = $trans[^4];
        $lit.push(|$lead);
        $trans = $trans.splice(4);
    } while $contbit eq '1';

    return $lit.join.parse-base(2).base(10);
}

say parse-pkt($trans);



# 78451082505 too low