
# Postprocesses to make it uniform
sub post-process( %data ) is export {
    my %processed-data = %data;
    if %data{"fuel tanks"} && %data{"vehicles"} {
        %processed-data{"vehicles and fuel tanks"} = {
            total => %data{"fuel tanks"}<total> +
                    %data{"vehicles"}<total>,
            delta => %data{"fuel tanks"}<delta> +
                    %data{"vehicles"}<delta>
        };

        %processed-data{"fuel tanks"}:delete;
        %processed-data{"vehicles"}:delete;
    }

    if %data{"boats / cutters"}  {
        %processed-data{"warships / boats"} = %data{"boats / cutters"};
        %processed-data{"boats / cutters"}:delete;
    }

    if %data{"особового складу / personnel"}  {
        %processed-data{"personnel"} = %data{"особового складу / personnel"};
        %processed-data{"особового складу / personnel"}:delete;
    }

    %processed-data{"cruise missiles"} = { :0total, :0delta } unless
      %processed-data{"cruise missiles"};

    %processed-data{"mobile SRBM system"}:delete;
    return %processed-data;
}

sub scrape( @lines ) is export {
    my @losses-lines = @lines.grep: /^\h*"<p>".+"</p>"/ ;
    my %data;
    for @losses-lines.grep: /"‒"|"–"|"-"/ -> $l {
        my $match;
        if $l ~~ /"&nbsp;about"/ {
            $match = $l ~~ /'p>'
            $<concept> = [.+] "‒ &nbsp;about" \h+
            $<total> = [\d*]
            \s* [\( "+"]?
            $<delta> = [[\d+]]? /;
        } else {
            $match = $l ~~ /'p>'
            $<concept> = [.+] \s+ ['‒' | '–' | '-'] \s* "about"? \s*
            $<total> = [\d*]
            \s* [\( "+"]?
            $<delta> = [[\d+]]? /;
        }
        warn " ⚠️ «$l» can't be properly parsed" unless $match{'concept'};
        warn " ⚠️ «$l» has problems with numbers" unless $match{'total'};
        next unless $match{'concept'} and $match{'total'};
        %data{~$match{'concept'}} = {
              total => +$match{'total'},
              delta => +$match{'delta'} ??  +$match{'delta'} !! 0;
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
    self.bless( :$date, data => post-process(scrape($uri.IO.lines)) );
}

multi method new( $str, $date = DateTime.now,) {
    self.bless( :$date, data => post-process(scrape($str.lines)) );
}

method data() {
    return %!data;
}

method columns() returns Sequence {
    return %!data.keys().sort();
}

method data-for( $key ) {
    if %!data{$key}:exists {
        return %!data{$key};
    } else {
        return Failure.new( "No such column in this data" );
    }
}

