use Test;

use Data::UkraineWar::MoD::Daily;

constant $data-file = "data/example.html";
my $path = $data-file.IO.e ?? "" !! "t/";

my @helicopters = [175, 186, 170, 140, 155, 193];
my @uavs = [8,4,11,0,4,3];
my @APVs = [3392, 3736,3213,1946,2445,4076];
my @fuel-tanks = [2360,2610,2217,1482,1777, 2998];
my @personnel = [31150,35750,29450,19600,23200,42640];
for ( $data-file, "data/july-1.html",
      "data/may-25-05.html", "data/first.html",
      "data/april-30-04.html", "data/aug-09.html") -> $uri {
    my $daily = Data::UkraineWar::MoD::Daily.new("$path$uri");
    diag("Testing $uri");
    ok($daily, "Loads daily file from test data");
    is($daily.columns().elems(), 13, "Got correct keys");
    is($daily.data-for("helicopters")<total>,shift @helicopters);
    is($daily.data-for("UAV operational-tactical level")<delta>,shift @uavs);
    is($daily.data-for("APV")<total>,shift @APVs);
    is($daily.data-for("vehicles and fuel tanks")<total>,shift @fuel-tanks);
    is($daily.data-for("personnel")<total>,shift @personnel);
    throws-like( { $daily.data-for("foobar") },
            X::AdHoc,
            message => /"No such"/);
}

done-testing;
