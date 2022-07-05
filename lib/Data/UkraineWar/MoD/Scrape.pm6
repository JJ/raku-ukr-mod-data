use Data::UkraineWar::MoD::Daily;

unit class Data::UkraineWar::MoD::Scrape;

has %!data;
has @!invalid;
has @!columns;

submethod BUILD( :%!data, :@!invalid, :@!columns ) {};

method new( $directory ) {
    my %data;
    my @invalid;
    my @columns;
    for dir( $directory, test => { /\.html$/ }) -> $file {
        my $content = $file.slurp;
        if ( $content ~~ / "<p>APV"/ ) {
            $file ~~ /$<date> = [\d+\.\d+] \s+ \|/;
            my $daily = Data::UkraineWar::MoD::Daily.new( $content, ~$<date> );
            if !@columns {
                @columns = $daily.columns();
            } elsif @columns.join(".") ne $daily.columns().join(".") {
                return Failure.new("Unknown columns: \n{@columns.join(".")}\n{$daily.columns().join(".")}");
            }
            %data{~$<date>} = $daily.data;
        } else {
            @invalid.push: $file.path;
        }
    }
    self.bless( :%data, :@invalid, :@columns );
}

method data() { %!data };

method CSV() {
    my $output = "Date, Item, Delta, Total\n";
    for %!data
            .keys()
            .sort( {
                $^a.split(".").reverse() cmp $^b.split(".").reverse()
            }) -> $k {
        for  %!data{$k}.keys().sort() -> $dk {
            $output ~=
                    "$k, $dk, " ~ %!data{$k}{$dk}<delta total>.join(", ")  ~
                    "\n";
        }
    }
    return  $output;
}

method invalid-files() {
    return @!invalid.map( '"' ~ * ~ '"' ).join( " " )
}
