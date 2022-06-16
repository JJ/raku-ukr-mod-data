#!/usr/bin/env raku

use Data::UkraineWar::MoD::Scrape;
my $dir = @*ARGS[0] // "raw-pages";

my $data = Data::UkraineWar::MoD::Scrape.new( $dir );
if $data.invalid-files() {
    say " ❌ → Invalid \n", $data.invalid-files();
} else {
    say $data.CSV;
}
