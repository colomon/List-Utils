use v6;
use Test;
use List::Utils;

my @array = (1, 2, 2, 3, 4, 5, 5, 5, 5, 6, 7, 8);

ok(([<=] @array), "array is sorted properly");

for (1.5, 2, 2.5, 3, 3.5, 4, 5.5, 6, 8) -> $x
{
    my $i = lower-bound(@array, $x);
    ok(@array[$i - 1] < $x <= @array[$i], "lower bound - 1 < $x <= lower bound");
}

is(lower-bound(@array, 8.5), @array.elems, "Off the big end returns max_index + 1");
is(upper-bound(@array, 0.5), 0, "Off the little end returns 0");

for (1.5, 2, 2.5, 3, 3.5, 4, 5.5, 6) -> $x
{
    my $i = upper-bound(@array, $x);
    ok(@array[$i - 1] <= $x < @array[$i], "upper bound - 1 <= $x < upper bound");
}

is(lower-bound(@array, 8), @array.elems - 1, "Equal to the big end returns max_index");
is(lower-bound(@array, 8.5), @array.elems, "Off the big end returns max_index + 1");

my @masak = flat "a" xx 10, "b" xx 100;
is binary-search(@masak, * eq "a"), 10, 'binary-search finds a/b boundary';
{
    my $count = 0;
    is binary-search(@masak, { $count++; $_ eq "a" }), 10, 'binary-search finds a/b boundary';
    ok $count < 8, "Doesn't do extra tests";
}

my @alpha = <a a b c c c d e f f>;

for "b".."f" -> $x {
    my $i = lower-bound(@alpha, $x);
    ok @alpha[$i - 1] lt $x le @alpha[$i], "lower bound - 1 lt $x le lower bound";
}

is lower-bound(@alpha, "f"), @alpha.elems - 2, "Equal to the big end returns max_index - 1"; # - 1 because "f" is doubled
is lower-bound(@alpha, "g"), @alpha.elems, "Off the big end returns max_index + 1";

for "b".."e" -> $x
{
    my $i = upper-bound(@alpha, $x);
    ok @alpha[$i - 1] le $x lt @alpha[$i], "upper bound - 1 <= $x < upper bound";
}

done-testing;
