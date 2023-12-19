my %dirs = 'U' => (-1, 0), 'D' => (1, 0), 'L' => (0, -1), 'R' => (0, 1);

my @h;
my @v;

my @start = (0, 0);
for "d18.txt".IO.lines>>.split(' ') -> ($dir, $mag, $rest) {
    my @vector = %dirs{ $dir }.map(* * $mag);
    my @end = @start Z+ @vector;
    
    @v.push((@start[1], |(@start[0], @end[0]).sort)) if $dir eq 'U'|'D';
    @h.push((@start[0], |(@start[1], @end[1]).sort)) if $dir eq 'L'|'R';

    @start = @end;
}

@h = @h.sort();
@v = @v.sort();

my %per;

my $total = 0;
for @h.rotor(2 => -1) X @v.rotor(2 => -1) -> (@hbox, @vbox) {
    my $area = (@hbox[1][0] - @hbox[0][0] - 1) * (@vbox[1][0] - @vbox[0][0] - 1);
    next if (@hbox[1][0] - @hbox[0][0] - 1) < 0 or (@vbox[1][0] - @vbox[0][0] - 1) < 0;

    my $h = (@hbox[0][0] + @hbox[1][0]) / 2;
    my $v = (@vbox[0][0] + @vbox[1][0]) / 2;

    my $outside = @v.grep({ .[0] < $v }).grep({ .[1] <= $h <= .[2] }).elems %% 2;
    next if $outside;

    $total += $area;

    %per{ (@hbox[0][0], @vbox[0][0], @vbox[1][0]).join('_') } = @vbox[1][0] - @vbox[0][0] - 1;
    %per{ (@hbox[1][0], @vbox[0][0], @vbox[1][0]).join('_') } = @vbox[1][0] - @vbox[0][0] - 1;

    %per{ (@vbox[0][0], @hbox[0][0], @hbox[1][0]).join('_') } = @hbox[1][0] - @hbox[0][0] - 1;
    %per{ (@vbox[1][0], @hbox[0][0], @hbox[1][0]).join('_') } = @hbox[1][0] - @hbox[0][0] - 1;

    %per{ (@hbox[0][0], @vbox[0][0]).join("_") } = 1;
    %per{ (@hbox[1][0], @vbox[1][0]).join("_") } = 1;

    %per{ (@hbox[0][0], @vbox[1][0]).join("_") } = 1;
    %per{ (@hbox[1][0], @vbox[0][0]).join("_") } = 1;
}

say $total + %per.values.sum;
