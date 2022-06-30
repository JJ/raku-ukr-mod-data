use Data::UkraineWar::MoD::Daily;

unit class Data::UkraineWar::MoD::Scrape;

has %!data;
has @!invalid;

submethod BUILD( :%!data, :@!invalid ) {};

method new( $directory ) {
    my %data;
    my @invalid;
    for dir( $directory, test => { /\.html$/ }) -> $file {
        my $content = $file.slurp;
        if ( $content ~~ / "<p>APV"/ ) {
            $file ~~ /$<date> = [\d+\.\d+] \s+ \|/;
            my $daily = Data::UkraineWar::MoD::Daily( $content, ~$<date> );
            %data{~$<date>} = $daily.data;
        } else {
            @invalid.push: $file.path;
        }
    }
    self.bless( :%data, :@invalid );
}

method data() { %!data };

method CSV() {
    my $output = "Date, Item, Delta, Total\n";
    for %!data
            .keys()
            .sort( {
                $^a.split(".").reverse() cmp $^b.split(".").reverse()
            }) -> $k {
        for  %!data{$k}.kv() -> $dk, %v {
            say %!data{$k};
            say $dk;
            $output ~= "$k, $dk, " ~ %v.values().join(", ") ~ "\n";
        }
    }
    return  $output;
}

method invalid-files() {
    return @!invalid.map( '"' ~ * ~ '"' ).join( " " )
}
