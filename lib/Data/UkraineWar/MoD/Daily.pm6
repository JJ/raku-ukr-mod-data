sub scrape( @lines ) is export {
    my @losses-lines = @lines.grep: /^"<p>".+"</p>"/ ;
    my %data;
    for @losses-lines.grep: /"‒"|"–"|"-"/ -> $l {
        my $match = $l ~~ /'p>'
            $<concept> = [ .+ ] \s+ ['‒'|'–'|'-'] \s+ "about"? \s*
            $<total> = [\d+]
            \s+ [\( "+"]?
            $<delta> = [[\d+]]? /;
        warn " ⚠️ «$l» can't be properly parsed" unless $match{'concept'};
        warn " ⚠️ «$l» has problems with numbers" unless $match{'total'};
        next unless $match{'concept'} and $match{'total'};
        %data{~$match{'concept'}} = {
              total => ~$match{'total'},
              delta => $match{'delta'} ??  $match{'delta'} !! 0;
        };
    }
    return %data;
}
unit class Data::UkraineWar::MoD::Daily;

has %!data;
has $!date;

proto new(|) {*}

submethod BUILD( :%!data, :$!date) {}

multi method new( $uri where .IO.e, $date = DateTime.now,) {
    self.bless( :$date, data => scrape($uri.IO.lines) );
}

multi method new( $str, $date = DateTime.now,) {
    self.bless( :$date, data => scrape($str.lines) );
}

method data() {
    return %!data;
}

method data-for( $key ) {
    return %!data{$key};
}

