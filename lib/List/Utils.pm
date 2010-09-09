module List::Utils;

sub sliding-window(@a, $n) is export(:DEFAULT) {
    my $a-list = @a.iterator.list;
    my @values;
    gather while my $a = $a-list.shift {
        @values.push($a);
        @values.shift if +@values > $n;
        take @values if +@values == $n;
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

sub transpose(@list is copy) is export(:DEFAULT) {
    gather {
        while @list !~~ [] {
            my @heads;
            if @list[0] ~~ Numeric {
                @heads = @list.shift;
            }
            else {
                @heads = @list.map({$_.shift unless $_ ~~ []});
            }
            @list = map {$_ unless $_ ~~ []}, @list;
            take [@heads];
        }
    }
}

