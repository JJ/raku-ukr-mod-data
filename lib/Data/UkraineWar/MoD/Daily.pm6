use LWP::Simple;

sub scrape( @lines ) is export {
    my @losses-lines = @lines.grep: /^"<p>".+"</p>"/ ;
    my %data;
    for @losses-lines.grep: /"‒"/ -> $l {
        my $match = $l ~~ /'p>'
            $<concept> = [ .+ ] \s+ '‒' \s+
            $<total> = [\d+]\s+ \( "+"
            $<delta> = [\d+] /;
        %data{$match{'concept'}} = {
              total => $match{'total'},
              delta => $match{'delta'}
        };
    }
}
unit class Data::UkraineWar::MoD::Daily;

has %!data;
has DateTime $!date;

proto new(|) {*}

multi method new( $URI where /^https:/, $date = now  ) {
    self.bless( :$date, data => LWP::Simple.get($URI).split("\n") );
}

multi method new( $uri, $date = now,) {
    self.bless( :$date, data => $uri.IO.lines );
}
