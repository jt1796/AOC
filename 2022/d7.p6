my %files;
my @dirs;

for open('d7.txt').lines {
    my $line =  $_;
    given $line {
        when /\$\scd\s\// { @dirs = ('/') }
        when /\$\scd\s\.\./ { @dirs.pop }
        when /\$\scd\s(.*)/ { @dirs.push: $/[0] ~ '/' }
        when /(\d+)\s(.*)/ { %files{$_} += $/[0] for [\~] @dirs }
    }
}

say %files.values.grep(30000000 + %files{'/'} - * <= 70000000).min;
