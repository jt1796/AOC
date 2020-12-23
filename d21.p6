my %book;
my $ingredients = SetHash.new;
my %counter is default(0);

open('d21.txt').lines.map({
    my @parts = .words with TR/)(,//;
    my @poisons;
    my @ingredients;
    for @parts {
        @poisons.push($_) if "contains" ^ff *;
        @ingredients.push($_) unless "contains" ff *;
    }

    for @poisons -> $poison {
        %book{ $poison }.push(@ingredients);
    }

    for @ingredients {
        %counter{$_}++;
        $ingredients.set($_);
    }
}).eager;

for %book {
    my $intersection = [∩] .value.map: *.List;
    %book{ .key } := $intersection.keys.List;
}

my $invalids = $ingredients (-) %book.values.flat;

my @reals = gather while %book.elems {
    my $victim = %book.first({ .value.elems == 1 });
    take $victim.value[0], $victim.key;
    %book{ $victim.key }:delete;
    for %book {
        %book{ .key } := .value.grep({ $_ ne $victim.value });
    }
}

say @reals.sort({ .[1].Str }).map({ .[0] }).join(',');