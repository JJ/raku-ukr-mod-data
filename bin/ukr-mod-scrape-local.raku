#!/usr/bin/env raku

use Data::UkraineWar::MoD::Scrape;
my $dir = @*ARGS[0] // "raw-pages";

my $data = Data::UkraineWar::MoD::Scrape.new( $dir );
say " ❌ → Invalid \n", $data.invalid-files();
say $data.CSV;
