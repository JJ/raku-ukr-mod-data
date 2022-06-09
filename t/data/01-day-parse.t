use Test;

use Data::UkraineWar::MoD::Daily;

constant $data-file = "data/example.html";
my $path = $data-file.IO.e ?? $data-file !! "t/$data-file";

my $daily = Data::UkraineWar::MoD::Daily.new( $path );

ok( $daily, "Loads daily file from test data");

done-testing;
