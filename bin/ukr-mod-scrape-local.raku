#!/usr/bin/env raku

use Data::UkraineWar::MoD::Scrape;
my $dir = @*ARGS[0] // "raw-pages";

say Data::UkraineWar::MoD::Scrape.new( $dir ).CSV;
