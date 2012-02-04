use Test;
use List::Utils;

nok transpose(([])).elems, "empty matrix";
is transpose(([],[])), (), "empty matrix";
is transpose(([1])), ([1]), "one element matrix";
is transpose(([1,2,3])), ([1],[2],[3]), "one line only matrix";
is transpose(([1,2,3])).join('|'), '1|2|3', 'one line matrix (structure)';
is transpose(([1,2,3],[4,5,6])), ([1,4],[2,5],[3,6]), "simple matrix";
is transpose(([1,2,3,4,5],[6],[7,8,9],[10,11])), ([1,6,7,10],[2,8,11],[3,9],[4],[5]), "strange matrix";
is transpose(([1,2,3,4,5],[6],[7,8,9],[10,11])).join('|'),
        '1 6 7 10|2 8 11|3 9|4|5', "strange matrix (structure)";

is transpose(([<a b c d e>],[<f>],[<g h i>],[<j k>])).join('|'),
    'a f g j|b h k|c i|d|e', "strange matrix with strings (structure)";

done;
