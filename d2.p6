my @input = open('d2.txt').lines;

@input.grep({
    $_ ~~ m/(<digit>+)\-(<digit>+)\s(<alnum>)\:\s(<alnum>+)/;
    ~$3.split('')[+$0, +$1].one eq ~$2;
}).elems.say;
