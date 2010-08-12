use Test;
use List::Utils;

plan *;

is ~sliding-window((1, 2, 3), 1), ~(1, 2, 3), "one at a time works (parcel)";
is ~sliding-window(1..3, 1), ~(1, 2, 3), "one at a time works (range)";
# is ~sliding-window(1...3, 1), ~(1, 2, 3), "one at a time works (series)";

is ~sliding-window((1, 2, 3, 4, 5), 2), ~(1, 2, 2, 3, 3, 4, 4, 5), "two at a time works (parcel)";
is ~sliding-window(1..5, 2), ~(1, 2, 2, 3, 3, 4, 4, 5), "two at a time works (range)";

is ~sliding-window((1, 2, 3, 4, 5), 3), ~(1, 2, 3, 2, 3, 4, 3, 4, 5), "three at a time works (parcel)";
is ~sliding-window(1..5, 3), ~(1, 2, 3, 2, 3, 4, 3, 4, 5), "three at a time works (range)";

done_testing;