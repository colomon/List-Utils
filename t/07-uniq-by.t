use Test;
use List::Utils;

is uniq-by(<A B C a b c d D e>, *.uc), <A B C d e>, "simple alphabetic test with uc";
# is uniq-by((1..* Z -2..*), *.abs)[^10], (1, -2, 3, 0, 4, 5, 6, 7, 8, 9), "test laziness with abs";

done-testing;