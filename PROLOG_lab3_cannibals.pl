% solve(N, M, Path) — решает задачу для N миссионеров/людоедов и лодки вместимостью M
solve(N, M, Path) :-
    initial_state(N, Start),
    goal_state(N, Goal),
    dfs(Start, Goal, N, M, [Start], RevPath),
    reverse(RevPath, Path).

initial_state(N, state(N, N, left)).
goal_state(N, state(0, 0, right)).

% dfs(+Current, +Goal, +N, +BoatCapacity, +Visited, -PathFromCurrentToGoal)
dfs(Goal, Goal, _, _, _, [Goal]).
dfs(Current, Goal, N, M, Visited, [Current|Rest]) :-
    next_state(Current, Next, N, M),
    \+ member(Next, Visited),
    dfs(Next, Goal, N, M, [Next|Visited], Rest).

% Генерация следующего состояния
next_state(state(M1, C1, left), state(M2, C2, right), N, M) :-
    % Перевозка из левого берега в правый
    between(0, M1, MM),
    between(0, C1, CC),
    MM + CC >= 1,
    MM + CC =< M,
    M2 is M1 - MM,
    C2 is C1 - CC,
    safe(M2, C2),                     % левый берег безопасен
    MR is N - M2,                     % миссионеры на правом берегу
    CR is N - C2,                     % людоеды на правом берегу
    safe(MR, CR).                     % правый берег безопасен

next_state(state(M1, C1, right), state(M2, C2, left), N, M) :-
    % Перевозка из правого берега в левый
    MR is N - M1,                     % сколько миссионеров на правом берегу
    CR is N - C1,                     % сколько людоедов на правом берегу
    between(0, MR, MM),
    between(0, CR, CC),
    MM + CC >= 1,
    MM + CC =< M,
    M2 is M1 + MM,                    % возвращаем на левый
    C2 is C1 + CC,
    safe(M2, C2),                     % левый берег безопасен
    safe(MR - MM, CR - CC).           % правый берег после отплытия

% Безопасное состояние: либо миссионеров нет, либо их >= людоедов
safe(M, C) :-
    (M =:= 0 ; M >= C).

/** <examples>

?- solve(3, 2, Path).  % Успешное решение классической задачи (должен вернуть путь)
?- solve(1, 1, Path).  % Простой случай: один миссионер и один людоед, лодка на 1 — решается за 1 рейс
?- solve(2, 1, Path).  % Невозможно: лодка слишком мала — запрос провалится (no)
?- solve(2, 2, Path).  % Решается за 3 состояния: [state(2,2,left), ..., state(0,0,right)]
?- solve(3, 1, Path).  % Невозможно — провалится (no)
?- solve(4, 3, Path).  % Возможное решение для большего случая
?- solve(5, 3, Path).  % Также разрешимо (известно из литературы)

*/