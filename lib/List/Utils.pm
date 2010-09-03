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

sub permute(@items) is export(:DEFAULT) {
    sub pattern_to_permutation(@pattern, @items1) {
        my @items = @items1;
        my @r;
        for @pattern {
            push @r, @items.splice($_, 1);
        }
        @r;
    }

    sub n_to_pat($n is copy, $length) {
        my @odometer;
        for 1 .. $length -> $i {
            unshift @odometer, $n % $i;
            $n div= $i;
        }
        return $n ?? () !! @odometer;
    }
    
    my $n = 0;
    gather loop {
        my @pattern = n_to_pat($n++, +@items);
        last unless ?@pattern;
        take pattern_to_permutation(@pattern, @items).item;
    }
}

sub take-while(@a, Mu $test) is export(:DEFAULT) {
    gather {
        for @a.list {
            when $test { take $_ }
            last;
        }
    }
}

