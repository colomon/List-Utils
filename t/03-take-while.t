use Test;
use List::Utils;

is take-while((1...*), * <= 10), ~(1...10), "take-while works on a basic infinite loop";
is take-while((1...*), * <= -1), "", "take-while works if condition is initially false";

done-testing;