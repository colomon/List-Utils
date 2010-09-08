use Test;
use List::Utils;

plan *;

is transpose(([])), (), "empty matrix";
is transpose(([],[])), (), "empty matrix";
is transpose(([1])), ([1]), "one element matrix";
is transpose(([1,2,3])), ([1],[2],[3]), "one line only matrix";
is transpose(([1,2,3],[4,5,6])), ([1,4],[2,5],[3,6]), "simple matrix";
is transpose(([1,2,3,4,5],[6],[7,8,9],[10,11])), ([1,6,7,10],[2,8,11],[3,9],[4],[5]), "strange matrix";

done_testing;
