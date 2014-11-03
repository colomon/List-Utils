module List::Utils;

sub push-one-take-if-enough(@values is rw, $new-value, $n) {
    @values.push($new-value);
    @values.shift if +@values > $n;
    if +@values == $n {
        for @values { take $_ }
    }
}

sub sliding-window(@a, $n) is export {
    my @values;
    gather for @a -> $a {
        push-one-take-if-enough(@values, $a, $n);
    }
}

sub sliding-window-wrapped(@a, $n) is export {
    my @values;
    gather {
        for @a -> $a {
            push-one-take-if-enough(@values, $a, $n);
        }
        
        for ^($n-1) {
            push-one-take-if-enough(@values, @a[$_], $n);
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

proto combinations(@items, $count?) is export { * }

multi sub combinations(@items, $count) is export {
    my $size = +@items;
    my $top = $size - $count;
    my @indicies = (^$count).list;
    gather loop {
        take [@items[@indicies]];
        last if !@indicies || @indicies[0] == $top;
        for $count - 1 ... 0 -> $i {
            if @indicies[$i] < $top + $i {
                @indicies[$i]++;
                for ($i+1)..^$count -> $j {
                    @indicies[$j] = @indicies[$j-1] + 1;
                }
                last;
            }
        }
    }
}

multi sub combinations(@items, Range $counts = 0..+@items) is export {
    $counts.map({ combinations(@items, $_) });
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

sub binary-search(@x, &test) is export {
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (&test(@x[$first + $half]))
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

sub lower-bound(@x, $key) is export {
    binary-search(@x, * before $key);
}

sub upper-bound(@x, $key) is export {
    binary-search(@x, * !after $key);
}

sub sorted-merge(@a, @b, &by = &infix:<cmp>) is export {
    if $*EXECUTABLE_NAME ~~ /:i niecza/ {
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
    } else {
        my $a-list = @a.iterator.list;
        my $b-list = @b.iterator.list;

        my $a = $a-list.shift // Mu;
        my $b = $b-list.shift // Mu;
        gather loop {
            if $a.defined && $b.defined {
                if &by($a, $b) == -1 {
                    my $temp = $a;
                    take $temp;
                    $a = $a-list.shift // Mu;
                } else {
                    my $temp = $b;
                    take $temp;
                    $b = $b-list.shift // Mu;
                }
            } else {
                if $a.defined {
                    my $temp = $a;
                    take $temp;
                    $a = $a-list.shift // Mu;
                } elsif $b.defined {
                    my $temp = $b;
                    take $temp;
                    $b = $b-list.shift // Mu;
                } else {
                    last;
                }
            }
        }
    }
}

sub uniq-by(@a, $by) is export {
    my %seen;
    gather for @a {
        my $current = $by($_);
        unless %seen{$current} {
            take $_;
            %seen{$current} = 1;
        }
    }
}
