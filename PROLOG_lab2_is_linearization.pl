% отдельно проверяем,что первый - список списокв
is_list_of_lists([]).  % Пустой список - выход из рекурсии, база
is_list_of_lists([H|T]) :-
    is_list(H),       
    is_list_of_lists(T).  % сама рекурсия

% Искомое отношение линеаризации
is_linearization(List, Accum) :-
    is_list_of_lists(List),       
    is_linearization_helper(List, Accum).

% База
is_linearization_helper([], []).
% Рекурсия
is_linearization_helper([H|T], Accum) :-
    is_linearization_helper(T, Linear_Tail),
    append(H, Linear_Tail, Accum).

/** <examples>

?- is_linearization([], X).
?- is_linearization([[1,2], [3,4]], X).
?- is_linearization([[1,2,3,4,5]], X).
?- is_linearization([[], [1,2], []], X).
?- is_linearization([[1], [2,3,4], [5,6]], X).
?- is_linearization([[a,b], [c,d]], [a,b,c,d]).
?- is_linearization([[1,2,3], [4,5,6], [7,8,9]], X).
?- is_linearization([['a','b'], ['c','d']], X).
?- is_linearization([[1,a], [b,2]], X).
?- is_linearization([[1,1], [2,2]], X).

?- is_linearization([1, [2,3]], X).
?- is_linearization([[1,2], abc, [3,4]], X).
?- is_linearization([[1,2], [c,d]], [a,b,c,d]).
?- is_linearization([[[1,2]], [3,4]], X).

*/
