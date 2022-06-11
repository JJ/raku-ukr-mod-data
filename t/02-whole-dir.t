use Test;

use Data::UkraineWar::MoD::Scrape;

my $war-data = Data::UkraineWar::MoD::Scrape.new( "raw-pages/" );

ok( $war-data, "Ukraine data loaded");
my $csv-output = $war-data.CSV();
ok( $csv-output, "Returns CSV correctly");
say $csv-output;

done-testing;
