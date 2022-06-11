use Data::UkraineWar::MoD::Daily;

unit class Data::UkraineWar::MoD::Scrape;

has %!data;

submethod BUILD( :%!data ) {};

method new( $directory ) {
    my %data;
    for dir( $directory, test => { /\.html$/ }) -> $file {
        my $content = $file.slurp;
        if ( $content ~~ / "<p>APV"/ ) {
            $file ~~ /$<date> = [\d+\.\d+] \s+ \|/;
            my $daily =  Data::UkraineWar::MoD::Daily( $content, ~$<date> );
            %data{~$<date>} = $daily.data;
        }
    }
    self.bless( :%data );
}

method data() { %!data };

method CSV() {
    my $output;
    for %!data
            .keys()
            .sort( {
                $^a.split(".").reverse() cmp $^b.split(".").reverse()
            }) -> $k {
        for  %!data{$k}.kv() -> $dk, %v {
            $output ~= "$k, $dk, " ~ %v.values().join(", ") ~ "\n";
        }
    }
    return  $output;
}