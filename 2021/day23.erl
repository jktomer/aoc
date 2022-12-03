#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day23e.txt", [read]),
    State = read_input(File),
    io:format("~p ~p~n", [State, search(State)]).

search(State) ->
    put(ts, os:timestamp()),
    search([{0, State}], #{}).

search([{Score, State} | Queue], Seen) ->
    Seen1 = Seen#{State => ok},
    (maps:size(Seen1) rem 1000 == 0) andalso
        begin
            Now = os:timestamp(),
            Lat = timer:now_diff(Now, get(ts)),
            put(ts, Now),
            io:format("~p ~p ~p ~p~n", [Score, length(Queue), maps:size(Seen1), 1.0e9/Lat])
        end,
    case done(State) of
        true ->
            Score;
        _ ->
            Moves = [{Score + Cost, State1} ||
                        {Cost, State1} <- legal_moves(State),
                        not maps:is_key(State1, Seen1)],
            search(lists:sort(Moves ++ [{C, S} || {C, S} <- Queue, not maps:is_key(S, Seen1)]), Seen1)
    end.

done([]) ->
    true;
done([{X, [A, A]} | T]) ->
    target(A) == X andalso done(T);
done(_) ->
    false.

legal_moves(State) ->
    lists:filtermap(
      fun legal_move/1,
      [{X0, X1, State} || X0 <- lists:seq(0, 10), X1 <- lists:seq(0, 10)]).

legal_move({X, X, _}) ->
    false;
legal_move({X0, X1, State}) ->
    legal_move(type(X0), type(X1), X0, X1, State).

legal_move(corridor, corridor, _, _, _) ->
    false;
legal_move(T0, T1, X0, X1, State) ->
    Who = legal_src(T0, X0, State),
    Who =/= false andalso
        legal_dest(T1, X1, Who, State) andalso
        legal_path(T0, X0, T1, X1, Who, State).

legal_src(corridor, X, State) ->
    proplists:get_value(X, State, false);
legal_src(room, X, State) ->
    Occupants = proplists:get_value(X, State, []),
    Resident = resident(X),
    lists:any(fun(A) -> A =/= Resident end, Occupants) andalso hd(Occupants).

legal_dest(corridor, _, _, _) ->
    true;
legal_dest(room, X, Who, State) ->
    X == target(Who) andalso
        not lists:any(fun(A) -> A =/= Who end, proplists:get_value(X, State, [])).

legal_path(T0, X0, T1, X1, Who, State) ->
    Blockers = [X || {X, _} <- State,
                     type(X) == corridor,
                     X > X0,
                     X < X1],
    case Blockers of
        [] ->
            {true, generate_move(T0, X0, T1, X1, Who, State)};
        _ -> false
    end.

generate_move(T0, X0, T1, X1, Who, State) ->
    {SCost, State1} = remove(T0, X0, State),
    {DCost, State2} = add(T1, X1, Who, State1),
    {energy_cost(Who) * (SCost + DCost + abs(X1 - X0)), lists:sort(State2)}.

remove(corridor, X, State) ->
    {0, proplists:delete(X, State)};
remove(room, X, State) ->
    [_ | Rest] = proplists:get_value(X, State),
    {2 - length(Rest), [{X, Rest} | proplists:delete(X, State)]}.

add(corridor, X, Who, State) ->
    {0, [{X, Who} | State]};
add(room, X, Who, State) ->
    Prev = proplists:get_value(X, State, []),
    {2 - length(Prev), [{X, [Who | Prev]} | proplists:delete(X, State)]}.

read_input(File) ->
    {ok, _} = file:read_line(File),
    {ok, _} = file:read_line(File),
    {ok, Outer} = file:read_line(File),
    {ok, Inner} = file:read_line(File),
    lists:sort(fill_rooms(Outer, fill_rooms(Inner, []))).

fill_rooms(Line, State) ->
    lists:foldl(
      fun({X, A}, SAcc) ->
              Old = proplists:get_value(X, SAcc, []),
              [{X, [A|Old]} | proplists:delete(X, SAcc)]
      end,
      State,
      lists:zip(lists:seq(2,8,2), [(C - $A) || [C] <- string:split(Line, "#", all), C =/= $\n])).

energy_cost(0) -> 1;
energy_cost(N) -> 10 * energy_cost(N-1).

target(A) -> 2 * A + 2.
resident(H) -> (H div 2) - 1.

type(2) -> room;
type(4) -> room;
type(6) -> room;
type(8) -> room;
type(_) -> corridor.
