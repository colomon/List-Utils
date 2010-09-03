use Test;
use List::Utils;

plan *;

{
    my @a = permute((1, 2, 3));
    say :@a.perl;
    is @a.elems, 6, "(1, 2, 3) has 6 permutations";
}

done_testing;
