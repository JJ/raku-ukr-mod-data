use Test;

use Data::UkraineWar::MoD::Daily;

constant $data-file = "data/example.html";
my $path = $data-file.IO.e ?? "" !! "t/";

my @helicopters = [175, 170, 140];
my @uavs = [8,11,0];
my @APVs = [3392, 3213,1946];
for ( $data-file, "data/may-25-05.html", "data/first.html" ) -> $uri {
    my $daily = Data::UkraineWar::MoD::Daily.new("$path$uri");
    ok($daily, "Loads daily file from test data");
    is($daily.data().keys().elems(), 13, "Got correct keys");
    is($daily.data-for("helicopters")<total>,shift @helicopters);
    is($daily.data-for("UAV operational-tactical level")<delta>,shift @uavs);
    is($daily.data-for("APV")<total>,shift @APVs);
}

done-testing;
