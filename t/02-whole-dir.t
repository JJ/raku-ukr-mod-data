use Test;

use Data::UkraineWar::MoD::Scrape;

my $war-data = Data::UkraineWar::MoD::Scrape.new( "raw-pages/" );

ok( $war-data, "Ukraine data loaded");
my $csv-output = $war-data.CSV();
ok( $csv-output, "Returns CSV correctly");
is( $csv-output.lines()[*-1].split(", ").elems, 4, "CSV rows correct");

$war-data.expand();
is( $war-data.data{"13.04"}<APV><delta>, 18, "Deltas added correctly");
is( $war-data.data{"26.05"}<APV><delta>, 22,
        "Deltas added correctly in intermediate dates");
is( $war-data.data{"26.05"}<APV><total>, 3235,
        "Totals added correctly in intermediate dates");

done-testing;
