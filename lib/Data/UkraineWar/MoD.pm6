use Data::UkraineWar::MoD::Daily;

unit class Data::UkraineWar::MoD;

has %!data;

method new( $directory ) {
    my %data;
    my $files;
    for dir( $directory, test => { /\.html$/ }) -> $file {
        my $content = $file.slurp;
        if ( $content !~~ / "<p>APV"/ ) {
            $files ~= "\"$file\" ";
        } else {
            $file ~~ /$<date> = [\d+\.\d+] \s+ \|/;
            my $daily =  Data::UkraineWar::MoD::Daily( $content, ~$<date> );
            %data{~$<date>} = $daily;
        }
    }
    say $files;
    self.bless( :%data );
}
