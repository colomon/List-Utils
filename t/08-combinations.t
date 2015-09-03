use Test;
use List::Utils;

sub postfix:<!>($n) { 
    [*] 1..$n
}

sub infix:<choose>($n, $k) {
    $n! div ($k! * ($n - $k)!)
}

sub are-unique-combinations(@c) {
    @c.map({ $_.sort.join("") }).Set == @c;
}

sub are-bits-of-combination-unique(@c) {
    @c.Set == @c;
}

sub are-bits-of-each-combination-unique(@c) {
    [&&] @c.map(&are-bits-of-combination-unique);
}

sub is-combination-from-source(@c, @source) {
    so @c.all (elem) @source;
}

sub are-combinations-from-source(@c, @source) {
    [&&] @c.map({ is-combination-from-source($_, @source) });
}

sub are-combinations-correct-length(@c, $count) {
    [&&] @c.map({ $_ == $count });
}

sub is-valid-combination(@c, @source, $count) {
    are-combinations-correct-length(@c, $count)
    && are-combinations-from-source(@c, @source)
    && are-bits-of-each-combination-unique(@c)
    && are-unique-combinations(@c)
    && @c == +@source choose $count;
}

ok are-unique-combinations([[<a b>], [<a c>], [<b c>]]), "Make sure are-unique-combinations helper works";
nok are-unique-combinations([[<a b>], [<b a>], [<b c>]]), "Make sure are-unique-combinations helper works";
ok is-combination-from-source(<a b>, <a b c>), "Make sure is-combination-from-source helper works";
nok is-combination-from-source(<a d>, <a b c>), "Make sure is-combination-from-source helper works";
ok are-combinations-correct-length([[<a b>], [<a c>], [<b c>]], 2), "Make sure are-combinations-correct-length helper works";
nok are-combinations-correct-length([[<a b>], [<a c>], [<b c d>]], 2), "Make sure are-combinations-correct-length helper works";
ok is-valid-combination([[<a b>], [<a c>], [<b c>]], "a".."c", 2), "Make sure is-valid-combination helper works";
nok is-valid-combination([[<a b>], [<a c>], [<b d>]], "a".."c", 2), "Make sure is-valid-combination helper works";
nok is-valid-combination([[<a b>], [<a b>], [<b c>]], "a".."c", 2), "Make sure is-valid-combination helper works";
nok is-valid-combination([[<a b>], [<b c>]], "a".."c", 2), "Make sure is-valid-combination helper works";

{
    my @c = combinations(<a b c d>, 0);
    is +@c, 1, "1 0-count combinations of a b c d";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "", "which is correct";
}

{
    my @c = combinations(<a b c d>, 1);
    is +@c, 4, "4 1-count combinations of a b c d";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a, b, c, d", "which is correct";
}

{
    my @c = combinations(<a b c d>, 2);
    is +@c, 6, "6 2-count combinations of a b c d";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a b, a c, a d, b c, b d, c d", "which is correct";
}

{
    my @c = combinations(<a b c d>, 3);
    is +@c, 4, "4 3-count combinations of a b c d";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a b c, a b d, a c d, b c d", "which is correct";
}

{
    my @c = combinations(<a b c d>, 4);
    is +@c, 1, "1 4-count combinations of a b c d";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), "a b c d", "which is correct";
}

for ^7 -> $count {
    ok is-valid-combination(combinations('a'..'g', $count), 'a'..'g', $count), "7 choose $count correct";
}

{
    my @c = combinations('a'..'z', 1);
    is +@c, 26, "26 1-count combinations of a-z";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
    is @c.sort.join(", "), ("a".."z").join(", "), "which is correct";
}

{
    my @c = combinations('a'..'z', 2);
    is +@c, 26 choose 2, "{26 choose 2} 2-count combinations of a-z";
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
}

{
    my @c := combinations('a'..'z', 3);
    isa-ok @c, List, "Result is a List";
    isa-ok @c[0], Array, "of Arrays";
}

done-testing;
