use Test;
use List::Utils;

sub postfix:<!>($n) { 
    [*] 1..$n
}

sub infix:<choose>($n, $k) {
    $n! div ($k! * ($n - $k)!)
}

{
    my @c = combinations(<a b c d>, 0);
    is +@c, 1, "1 0-count combinations of a b c d";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "", "which is correct";
}

{
    my @c = combinations(<a b c d>, 1);
    is +@c, 4, "4 1-count combinations of a b c d";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a, b, c, d", "which is correct";
}

{
    my @c = combinations(<a b c d>, 2);
    is +@c, 6, "6 2-count combinations of a b c d";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a b, a c, a d, b c, b d, c d", "which is correct";
}

{
    my @c = combinations(<a b c d>, 3);
    is +@c, 4, "4 3-count combinations of a b c d";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a b c, a b d, a c d, b c d", "which is correct";
}

{
    my @c = combinations(<a b c d>, 4);
    is +@c, 1, "1 4-count combinations of a b c d";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a b c d", "which is correct";
}

{
    my @c = combinations('a'..'z', 1);
    is +@c, 26, "26 1-count combinations of a-z";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), ("a".."z").join(", "), "which is correct";
}

{
    my @c = combinations('a'..'z', 2);
    is +@c, 26 choose 2, "{26 choose 2} 2-count combinations of a-z";
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
}

{
    my @c := combinations('a'..'z', 3);
    isa_ok @c, List, "Result is a List";
    isa_ok @c[0], Array, "of Arrays";
}

done;
