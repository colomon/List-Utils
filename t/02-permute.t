use Test;
use List::Utils;

{
    my @a = permute((1, 2, 3));
    is @a.elems, 6, "(1, 2, 3) has 6 permutations";
}

{
    my $a := permute(1..100);
    is $a[0].elems, 100, "permute(1..100) is lazy, and the first thing it returns is 100 elements long";
}

done-testing;
