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
    for dir( $directory, test => { /[\.html$ | ^"The total combat"]/ }) ->
    $file {
        my $content = $file.slurp;
        if ( $content ~~ / "<p>APV"/ ) {
            $file ~~ /"to" [\s|"-"] $<date> = [\d+\.\d+] \s+ \|?/;
            my $daily = Data::UkraineWar::MoD::Daily.new( $content, ~$<date> );
            if !@columns {
                @columns = $daily.columns();
            } elsif $daily.columns() ⊈ @columns {
                say @columns.raku;
                say $daily.columns().raku;
                return Failure.new("Unknown or missing columns in «$file» \n{
                    @columns.join(".")}\n{$daily.columns().join(".")
                }");
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

#| convert date in the web format to a real date for arithmetic
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
                    if ! %!data{$prev-date}{$key}<total> {
                        %!data{$prev-date}{$key}<total> =
                                %!data{$date}{$key}<total>;
                        %!data{$prev-date}{$key}<delta> = 0;

                    }
                    %!data{$date}{$key}<delta> = %!data{$date}{$key}<total> -
                            %!data{$prev-date}{$key}<total>
                }
            }
        }
        if $this-date - datify($prev-date) == 2 {
            my $intermediate-date = $this-date - 1;
            my $mid-date-key = sprintf("%02d",$intermediate-date.day) ~ "." ~
                    sprintf("%02d",$intermediate-date.month);
            for %!data{$date}.keys -> $key {
                %!data{$mid-date-key}{$key}<total> =
                        %!data{$date}{$key}<total> - %!data{$date}{$key}<delta>;
                %!data{$mid-date-key}{$key}<delta> =
                        %!data{$mid-date-key}{$key}<total> -
                        %!data{$prev-date}{$key}<total>;
            }
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
