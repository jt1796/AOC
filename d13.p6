my @input = open('d13.txt').lines;

my $time = @input[0];
my @buses = @input[1].split(',');

my $eqns = (@buses Z @buses.keys).map({
    "0 == Mod[x + $_[1], $_[0]]" if $_[0] ne "x";
}).join(",");

say "\{ $eqns }";

# too high 1658064091492211 

# (N + 0) % 17     ==
#  whatever
# (N + 2) % 13     ==
# (N + 3) % 19     ==
# 0

#  0 == N % 17 == (N+2) % 13 == (N+3) % 19
# N divides 17, N+2 divides 13, N+3 divides 19
# 17*x = N
# 13*y-2 = N
# 19*z-3 = N

# (17x + 13y + 19*z - 5) / 3 = N

# x = (13*y-2)/17



# N = 3417
