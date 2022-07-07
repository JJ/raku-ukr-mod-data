use Test;

use Data::UkraineWar::MoD::Scrape;

my $war-data = Data::UkraineWar::MoD::Scrape.new( "raw-pages/" );

ok( $war-data, "Ukraine data loaded");
my $csv-output = $war-data.CSV();
ok( $csv-output, "Returns CSV correctly");
is( $csv-output.lines()[*-1].split(", ").elems, 4, "CSV rows correct");

$war-data.expand();
is( $war-data.data{"13.04"}<APV><delta>, 18, "Deltas added correctly");
done-testing;
