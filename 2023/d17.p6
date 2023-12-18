use PriorityQueue;

my @grid = "d17.txt".IO.lines>>.comb>>.List.List;

# estimate about what the score will be at the end
sub score(@elem) { (@elem[3] + 4 * (+@grid - @elem[0][0] + +@grid[0] - @elem[0][1])) };
my $pq = PriorityQueue.new(:cmp(&score));

my @up = (-1, 0);
my @down = (1, 0);
my @left = (0, -1);
my @right = (0, 1);

my %lefts = @up => @left, @down => @right, @left => @down, @right => @up;
my %rights = @up => @right, @down => @left, @left => @up, @right => @down;

my %bests;
my $allbest = Inf;

$pq.push(((0, 0), @down, -1, -@grid[0][0]));
$pq.push(((0, 0), @right, -1, -@grid[0][0]));

while $pq.shift -> (@pos, @dir, $rem, $score) {
    if $score >= $allbest or $rem >= 10 or not defined @grid[@pos[0]][@pos[1]] {
        next;
    }

    my $bnbkey = (@pos, @dir, $rem).join("_");
    if %bests{ $bnbkey }:exists and %bests{ $bnbkey } <= $score {
        next;
    } else {
        %bests{ $bnbkey } = $score;
    }

    my $num = @grid[@pos[0]][@pos[1]] + $score;

    if @pos eq (+@grid - 1, +@grid[0] - 1) and $rem >= 3 {
        $allbest = $num min $allbest;
        say $num;
        next;
    }

    my @left := %lefts{ ~@dir };
    my @right := %rights{ ~@dir };

    $pq.push(((@pos Z+ @dir), @dir, $rem + 1, $num));
    if $rem >= 3 {
        $pq.push(((@pos Z+ @left), @left, 0, $num));
        $pq.push(((@pos Z+ @right), @right, 0, $num));
    }
}

say $allbest;