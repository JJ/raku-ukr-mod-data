use Test;

use Data::UkraineWar::MoD::Daily;

constant $data-file = "data/example.html";
my $path = $data-file.IO.e ?? $data-file !! "t/$data-file";
constant $URL = "https://www.mil.gov.ua/en/news/2022/06/04/the-total-combat-losses-of-the-enemy-from-24-02-to-04-06/";

for ( $path, $URL ) -> $uri {
    my $daily = Data::UkraineWar::MoD::Daily.new($uri);
    ok($daily, "Loads daily file from test data");
    is($daily.data().keys().elems(), 10, "Got correct keys");
}

done-testing;
