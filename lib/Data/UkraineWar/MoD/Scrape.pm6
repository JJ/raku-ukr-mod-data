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
    for %!data.keys().sort() -> $k {
        $output ~= %!data{$k}.join(", ") ~"\n";
    }
    return  $output;
}