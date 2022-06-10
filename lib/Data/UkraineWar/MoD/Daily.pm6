sub scrape( @lines ) is export {
    my @losses-lines = @lines.grep: /^"<p>".+"</p>"/ ;
    my %data;
    for @losses-lines.grep: /"‒"|"–"|"-"/ -> $l {
        my $match = $l ~~ /'p>'
            $<concept> = [ .+ ] \s+ ['‒'|'–'|'-'] \s+ \w* \s*
            $<total> = [\d+]\s+ \( "+"
            $<delta> = [\d+] /;
        warn "«$l» can't be properly parsed" unless $match{'concept'};
        %data{~$match{'concept'}} = {
              total => ~$match{'total'},
              delta => ~$match{'delta'}
        };
    }
    return %data;
}
unit class Data::UkraineWar::MoD::Daily;

has %!data;
has DateTime $!date;

proto new(|) {*}

submethod BUILD( :%!data, :$!date) {}

multi method new( $uri, $date = DateTime.now,) {
    self.bless( :$date, data => scrape($uri.IO.lines) );
}

method data() {
    return %!data;
}
