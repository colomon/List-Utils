use v6;
use Test;
use List::Utils;

plan *;

{
    my @a = (10, 20, 20, 30);
    my @b = 17..22;
    is ~sorted-merge(@a, @b), ~(10,17,18,19,20,20,20,21,22,30), "Simple sorted-merge correct";
    is ~sorted-merge(@b, @a), ~(10,17,18,19,20,20,20,21,22,30), "Simple sorted-merge correct, order swapped";
    is ~@a, ~(10, 20, 20, 30), 'Original @a unaffected';
    is ~@b, ~(17..22), 'Original @b unaffected';
}

{
    my @a = 1..3;
    my @b = 10..12;
    is ~sorted-merge(@a, @b), ~(1, 2, 3, 10, 11, 12), "sorted-merge correct if inputs do not overlap";
    is ~sorted-merge(@b, @a), ~(1, 2, 3, 10, 11, 12), "sorted-merge correct if inputs do not overlap, order swapped";
}

{
    my @a = 1..3;
    my @b;
    is ~sorted-merge(@a, @b), ~(1, 2, 3), "sorted-merge correct if one input is empty";
    is ~sorted-merge(@b, @a), ~(1, 2, 3), "sorted-merge correct if one input is empty, order swapped";
}

{
    my @a := 1, 1, *+* ... *;
    my @b := 3, 6 ... *;
    is ~sorted-merge(@a, @b)[^10], ~(1, 1, 2, 3, 3, 5, 6, 8, 9, 12), 
       "sorted-merge correct with infinite lazy lists";
    is ~sorted-merge(@b, @a)[^10], ~(1, 1, 2, 3, 3, 5, 6, 8, 9, 12), 
       "sorted-merge correct with infinite lazy lists, order swapped";
}


done_testing;