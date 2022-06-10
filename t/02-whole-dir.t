use Test;

use Data::UkraineWar::MoD;

my $war-data = Data::UkraineWar::MoD.new( "raw-pages/" );

ok( $war-data, "Ukraine data loaded");

done-testing;
