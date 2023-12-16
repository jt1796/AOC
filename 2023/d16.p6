my @grid = "d16.txt".IO.lines>>.comb;

my @up = (-1, 0);
my @down = (1, 0);
my @left = (0, -1);
my @right = (0, 1);

my %visited;

sub lightup(@loc, @dir) {
    my $marker = @grid[@loc[0]][@loc[1]] || 0;
    return if $marker eq 0;
    return if %visited{ @loc ~ '_' ~ @dir }:exists;

    %visited{ @loc ~ '_' ~ @dir } = 1;

    if $marker eq '/' {
        return lightup((@loc Z+ @right), @right) if @dir eq @up;
        return lightup((@loc Z+ @left),  @left)  if @dir eq @down;
        return lightup((@loc Z+ @down),  @down)  if @dir eq @left;
        return lightup((@loc Z+ @up),    @up)    if @dir eq @right;
    }

    if $marker eq '\\' {
        return lightup((@loc Z+ @left),  @left)  if @dir eq @up;
        return lightup((@loc Z+ @right), @right) if @dir eq @down;
        return lightup((@loc Z+ @up), @up)       if @dir eq @left;
        return lightup((@loc Z+ @down), @down)   if @dir eq @right;
    }

    if $marker eq '-' and @dir eq (@up, @down).any {
        lightup((@loc Z+ @left),  @left);
        return lightup((@loc Z+ @right), @right);
    }

    if $marker eq '|' and @dir eq (@left, @right).any {
        lightup((@loc Z+ @up),   @up);
        return lightup((@loc Z+ @down), @down);
    }

    lightup((@loc Z+ @dir), @dir);
}

lightup((0, 0), @right);

say %visited.keys.map(*.split("_")[0]).unique.elems;
