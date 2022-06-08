#!/usr/bin/env raku

my $file-name = @*ARGS[0] // "example.html";

my @losses-lines = $file-name.IO.lines.grep: /^"<p>".+"</p>"/ ;

for @losses-lines.grep: /"‒"/ -> $l {
    $l ~~ /"<p>" $<concept> = (.+?) \s* "‒"/;
    my $numbers = $l ~~ /(\d+) \s+ \( "+" (\d+) /;
    say $<concept>, $numbers;
}



