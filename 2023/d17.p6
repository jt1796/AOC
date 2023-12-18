my @grid = "d17.txt".IO.lines>>.comb>>.List.List;

use PriorityQueue;

#pq is ascending

# work on stuff close to exit:
# sub score(@elem) { -1 * (@elem[0][0] + @elem[0][1]) };
# work on stuff with a high score and close to exit
# sub score(@elem) { -1 * @elem[3] - (@elem[0][0] + @elem[0][1]) }; 

# want stuff with low score and close to exit?
# sub score(@elem) { 10 * @elem[3] - (@elem[0][0] + @elem[0][1]) }; 
# low average score first
# sub score(@elem) { (@elem[3] / (@elem[0][0] + @elem[0][1] + 3)) };

# score plus expected score to get to the end
sub score(@elem) { (@elem[3] + 4 * (+@grid - @elem[0][0] + +@grid[0] - @elem[0][1])) };

my $pq = PriorityQueue.new(:cmp(&score));

my @up = (-1, 0);
my @down = (1, 0);
my @left = (0, -1);
my @right = (0, 1);

my %lefts = @up => @left, @down => @right, @left => @down, @right => @up;
my %rights = @up => @right, @down => @left, @left => @up, @right => @down;

my %bests;
my $allbest = 1385;

$pq.push(((0, 0), @down, 3, -@grid[0][0]));
$pq.push(((0, 0), @right, 3, -@grid[0][0]));

while $pq.shift -> (@pos, @dir, $rem, $score) {
    my $guess = (@pos[0] - +@grid).abs + (@pos[1] - +@grid[0]).abs;
    if $score + $guess >= $allbest or $rem < 0 or not defined @grid[@pos[0]][@pos[1]] {
        next;
    }

    my $bnbkey = (@pos, @dir, $rem).join("_"); # and for any x <= $rem
    my $totalkey = (@pos, @dir, $rem, $score).join("_");
    if %bests{$totalkey}:exists {
        return %bests{$totalkey};
    } elsif %bests{ $bnbkey }:exists and %bests{ $bnbkey } <= $score {
        next;
    } elsif %bests{ ~@pos }:exists and %bests{ ~@pos } <= $score - 36 {
        next;
    } else {
        %bests{ ~@pos } = $score;
        %bests{ (@pos, @dir, $_).join("_") } = $score for 0..$rem;
    }

    my $num = @grid[@pos[0]][@pos[1]] + $score;

    if @pos eq (+@grid - 1, +@grid[0] - 1) {
        $allbest = $num min $allbest;
        say $num;
        next;
    }

    my @left := %lefts{ ~@dir };
    my @right := %rights{ ~@dir };

    (@left, @right, @dir).map({
        $pq.push(((@pos Z+ $_), $_, $_ eq @dir ?? $rem - 1 !! 2, $num),);
    }).eager;
}

say $allbest;
