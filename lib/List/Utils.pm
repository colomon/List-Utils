module List::Utils;

sub sliding-window(@a, $n) is export(:DEFAULT) {
    my $a-list = @a.list;
    my @values;
    gather while my $a = $a-list.shift {
        @values.push($a);
        @values.shift if +@values > $n;
        if +@values == $n {
            for @values -> $value {
                take $value;
            }
        }
    }
}
