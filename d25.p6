my @input = 6930903, 19716708;

sub transform($subject) {
    (1, { $_ * $subject % 20201227 } ... *);
}

sub findloop($val) {
    transform(7).first($val, :k);
}

my @loopsizes = @input.map: { findloop($_) };
say @loopsizes;
say (@loopsizes Z @input.rotate).map({ transform(.[1])[.[0]] });