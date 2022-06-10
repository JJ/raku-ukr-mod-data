use Data::UkraineWar::MoD::Daily;

unit class Data::UkraineWar::MoD;

has %!data;

method new( $directory ) {
    for dir( $directory, test => { /\.html$/ }) -> $file {
        my $content = $file.slurp;
        if ( $content !~~ / "<p>APV ‒ "/ ) {
            say "{$file.path} does not contain combat losses data";
        } else {
            my $daily =  Data::UkraineWar::MoD::Daily( $file.path );
            say $daily.data();
        }
    }
}
