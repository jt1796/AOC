my @passports = open('d4.txt').split(/\n\n/);

@passports.grep({
    my @fields = $_.comb(/(\S+)\:(\S+)/);
    my %passport = @fields.map: *.split(':').Slip.hash;
    my @required = ('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid');
    my $birth = 1920 <= %passport{ 'byr' } <= 2002;
    my $issue = 2010 <= %passport{ 'iyr' } <= 2020;
    my $expiry = 2020 <= %passport{'eyr'} <= 2030;
    my $heightNum = S:g/\D// with %passport{'hgt'};
    my $height = (%passport{'hgt'} ~~ m/cm/) ?? (150 <= $heightNum <= 193) !! (59 <= $heightNum <= 76);
    my $hair = %passport{'hcl'} ~~ m/^\#<alnum> ** 6$/;
    my $eye = so %passport{'ecl'} eq <amb blu brn gry grn hzl oth>.one;
    my $pid = %passport{'pid'} ~~ m/^\d ** 9$/;

    so ($birth, $issue, $expiry, $pid, $eye, $hair, $height).all;
}).elems.say;