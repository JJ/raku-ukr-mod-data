use Test;

use Data::UkraineWar::MoD::Scrape;

my $war-data = Data::UkraineWar::MoD::Scrape.new( "raw-pages/" );

ok( $war-data, "Ukraine data loaded");
my $csv-output = $war-data.CSV();
ok( $csv-output, "Returns CSV correctly");
is( $csv-output.lines()[*-1].split(", ").elems, 4, "CSV rows correct");
done-testing;
