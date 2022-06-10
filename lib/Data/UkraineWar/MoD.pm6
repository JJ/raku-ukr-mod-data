use Data::UkraineWar::MoD::Daily;

unit class Data::UkraineWar::MoD;

has %!data;

method new( $directory ) {
    my %data;
    for dir( $directory, test => { /\.html$/ }) -> $file {
        my $content = $file.slurp;
        if ( $content ~~ / "<p>APV"/ ) {
            $file ~~ /$<date> = [\d+\.\d+] \s+ \|/;
            my $daily =  Data::UkraineWar::MoD::Daily( $content, ~$<date> );
            %data{~$<date>} = $daily;
        }
    }
    self.bless( :%data );
}
