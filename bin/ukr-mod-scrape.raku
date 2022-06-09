#!/usr/bin/env raku

my $file-name = @*ARGS[0] // "example.html";

my @losses-lines = $file-name.IO.lines.grep: /^"<p>".+"</p>"/ ;

for @losses-lines.grep: /"‒"/ -> $l {
    my $match = $l ~~ /'p>'
        $<concept> = [ .+ ] \s+ '‒' \s+
        $<total> = [\d+]\s+ \( "+"
        $<delta> = [\d+] /;
    say $match;
}



