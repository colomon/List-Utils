module List::Utils;

sub sliding-window(@a, $n) is export {
    my $a-list = @a.iterator.list;
    my @values;
    gather while defined(my $a = $a-list.shift) {
        @values.push($a);
        @values.shift if +@values > $n;
        take @values if +@values == $n;
    }
}

sub sliding-window-wrapped(@a, $n) is export {
    my $a-list = @a.iterator.list;
    my @values;
    gather {
        while defined(my $a = $a-list.shift) {
            @values.push($a);
            @values.shift if +@values > $n;
            take @values if +@values == $n;
        }
        
        for ^($n-1) {
            @values.push(@a[$_]);
            @values.shift if +@values > $n;
            take @values if +@values == $n;
        }
    }
}

sub permute(@items) is export {
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

sub take-while(@a, Mu $test) is export {
    gather {
        for @a.list {
            when $test { take $_ }
            last;
        }
    }
}

sub transpose(@list is copy) is export {
    gather {
        while @list {
            my @heads;
            if @list[0] !~~ Positional {
                @heads = @list.shift;
            }
            else {
                @heads = @list.map({$_.shift unless $_ ~~ []});
            }
            @list = @list.map({$_ unless $_ ~~ []});
            take [@heads];
        }
    }
}

sub lower-bound(@x, $key) is export {
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (@x[$first + $half] < $key)
        {
            $first += $half + 1;
            $len -= $half + 1;
        }
        else
        {
            $len = $half;
        }
    }
    return $first;
}

sub upper-bound(@x, $key) is export {
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (@x[$first + $half] <= $key)
        {
            $first += $half + 1;
            $len -= $half + 1;
        }
        else
        {
            $len = $half;
        }
    }
    return $first;
}

sub sorted-merge(@a, @b, &by = &infix:<cmp>) is export {
    my $a-list = @a.iterator.list;
    my $b-list = @b.iterator.list;
    
    my $a = $a-list.shift;
    my $b = $b-list.shift;
    gather loop {
        if $a.defined && $b.defined {
            if &by($a, $b) == -1 {
                my $temp = $a;
                take $temp;
                $a = $a-list.shift;
            } else {
                my $temp = $b;
                take $temp;
                $b = $b-list.shift;
            }
        } else {
            if $a.defined {
                my $temp = $a;
                take $temp;
                $a = $a-list.shift;
            } elsif $b.defined {
                my $temp = $b;
                take $temp;
                $b = $b-list.shift;
            } else {
                last;
            }
        }
    }
}
