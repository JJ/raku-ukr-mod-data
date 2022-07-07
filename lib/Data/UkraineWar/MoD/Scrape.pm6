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

method dates() {
    %!data.keys()
            .sort( {
                $^a.split(".").reverse() cmp $^b.split(".").reverse()
            })
}

my sub datify( $date-key ) {
    Date.new(2022, |$date-key.split(".").reverse())
}

method expand() {
    my $prev-date = self.dates[0];
    for self.dates()[1..*] -> $date {
        my $this-date = datify( $date );
        if $this-date - datify($prev-date) == 1 {
            unless [*] %!data{$date}.values.map: *<delta> {
                for %!data{$date}.keys -> $key {
                    %!data{$date}{$key}<delta> = %!data{$date}{$key}<total> -
                            %!data{$prev-date}{$key}<total>
                }
            }
        }
        if $this-date - datify($prev-date) == 2 {
            my $intermediate-date = $this-date - 1;
            my $mid-date-key = sprintf("%02d",$intermediate-date.day) ~ "." ~
                    sprintf("%02d",$intermediate-date.month);
            say $mid-date-key;
        }

        $prev-date = $date;
    }

}

method CSV() {
    my $output = "Date, Item, Delta, Total\n";
    for self.dates() -> $k {
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
