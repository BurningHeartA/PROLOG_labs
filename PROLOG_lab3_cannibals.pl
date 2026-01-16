% Основной предикат решения
% Path = список состояний (Мис_слева, Кан_слева, где_лодка, Мис_справа, Кан_справа)
missioners_and_cannibals(N,M,Path) :-
    solve(N,M,Reversed_Path),
    reverse(Reversed_Path, Path).  % разворачивает путь, чтобы было читаемо

% Считай хелпер, просто добавляет проверок
solve(N, M, Path) :-
    N >= 1, M >= 2,
    initial_state(N, State),
    search(State, N, M, [], Path).

% Факты (начальное состояние и конечное)
initial_state(N, state(N, N, left, 0, 0)).
goal_state(N, state(0, 0, right, N, N)).

% Поиск решения
search(State, N, M, Visited, [State|Visited]) :-
    M >= 2,
    goal_state(N, State).

search(State, N, M, Visited, Path) :-
    transition(State, N, M, NextState), 			% переход в новое состояние, 
    \+ member(NextState, Visited),					% которое мы еще не посещали (чтобы не было циклов),
    safe_state(NextState),							% к тому же оно должно быть безопасным,
    search(NextState, N, M, [State|Visited], Path).	% ну и рекурсивно пытаемся достичь успеха

% Безопасность состояния в целом,  берегов в частности
safe_state(state(ML, CL, _, MR, CR)) :-
    safe_shore(ML, CL),
    safe_shore(MR, CR).
safe_shore(0, _) :- !.
safe_shore(M, C) :- M >= C.

% Переходы между состояниями
transition(state(ML, CL, Pos, MR, CR),
           N, M,
           state(New_ML, New_CL, New_Pos, New_MR, New_CR)) :-
    
    % Определяем, откуда и куда везем
    (Pos = left ->
        From_M = ML, From_C = CL,
        To_M = MR, To_C = CR
    ;
        From_M = MR, From_C = CR,
        To_M = ML, To_C = CL
    ),
    
    % Выбираем, кого посадить в лодку
    between(0, From_M, A),
    between(0, From_C, B),
    Boat is A + B,
    Boat >= 1, Boat =< M,
    
    % Забираем людей
    Dec_M is From_M - A,
    Dec_C is From_C - B,
    
    % Высаживаем всех на противоположном берегу
    Inc_M is To_M + A,
    Inc_C is To_C + B,
    
    % Вычисляем новое состояние
    (Pos = left ->
        New_ML = Dec_M, New_CL = Dec_C,
        New_MR = Inc_M, New_CR = Inc_C,
        New_Pos = right
    ;
        New_ML = Inc_M, New_CL = Inc_C,
        New_MR = Dec_M, New_CR = Dec_C,
        New_Pos = left
    ),
    
    % Проверки границ (на самом деле, это уже лишнее,
    %  потому что выбор инкремента/декремента выше определяет именно такие границы)
    New_ML >= 0, New_CL >= 0,
    New_MR >= 0, New_CR >= 0,
    New_ML =< N, New_CL =< N,
    New_MR =< N, New_CR =< N.


/** <examples>

?- missioners_and_cannibals(3, 2, Path).  % Успешное решение
?- missioners_and_cannibals(1, 1, Path).  % Невозможно: лодка слишком мала
?- missioners_and_cannibals(2, 1, Path).  % Невозможно: лодка слишком мала
?- missioners_and_cannibals(2, 2, Path).  % Решается просто
?- missioners_and_cannibals(1, 3, Path).  % Решается за один переход
?- missioners_and_cannibals(10, 3, Path). % Для наглядности
?- missioners_and_cannibals(10, 4, Path). % Для наглядности

*/
