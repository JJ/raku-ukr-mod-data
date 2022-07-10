use Test;

use Data::UkraineWar::MoD::Scrape;

my $war-data = Data::UkraineWar::MoD::Scrape.new( "raw-pages/" );

subtest "CSV works", {
    ok($war-data, "Ukraine data loaded");
    my $csv-output = $war-data.CSV();
    ok($csv-output, "Returns CSV correctly");
    is($csv-output.lines()[*- 1].split(", ").elems, 4, "CSV rows correct");
};

subtest "Expanding and processing works", {
    $war-data.expand();
    is($war-data.data{"13.04"}<APV><delta>, 18, "Deltas added correctly");
    is($war-data.data{"26.05"}<APV><delta>, 22,
            "Deltas added correctly in intermediate dates");
    is($war-data.data{"26.05"}<APV><total>, 3235,
            "Totals added correctly in intermediate dates");
}

subtest "Data is OK", {
    my @dates = $war-data.dates();
    my %prev = $war-data.data{@dates.shift};
    for @dates -> $date {
        for <tanks personnel> -> $k {
            cmp-ok $war-data.data{$date}{$k}<total>, ">=", %prev{$k}<total>,
                    "$k for $date: {$war-data.data{$date}{$k}<total>} ≥ {%prev{$k}<total>}";
        }
        %prev = $war-data.data{$date};
    }

}
done-testing;
