#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day15.txt", [read]),
    SmallMap = read_input(File),
    {{Width, Height}, _} = lists:max(maps:to_list(SmallMap)),
    Part1 = lowest_cost(SmallMap, {1, 1}, {Width, Height}),

    F = 5,
    BigMap = expand(SmallMap, Width, Height, F),
    Part2 = lowest_cost(BigMap, {1, 1}, {Width*F, Height*F}),

    io:format("~p ~p~n", [Part1, Part2]).

expand(Map, Width, Height, Factor) ->
    lists:foldl(fun maps:merge/2, #{}, [gen_tile(Map, Width, Height, X, Y) || X <- lists:seq(0, Factor-1),
                                                                               Y <- lists:seq(0, Factor-1)]).
gen_tile(Map, Width, Height, TX, TY) ->
    maps:from_list(
      [{{X + TX * Width, Y + TY * Height},
        ((V + TX + TY - 1) rem 9) + 1}
       || {{X, Y}, V} <- maps:to_list(Map)]).

lowest_cost(Costs, Start, Goal) ->
    #{Goal := Cost} = shortest_path(Start, #{}, #{Start => 0}, Goal, Costs),
    Cost.

shortest_path(Node = {X, Y}, Known, Tentative, Goal = {GX, GY}, Costs) ->
    Neighbors = [{X-1, Y}, {X+1, Y}, {X, Y+1}, {X, Y-1}],
    GoodNeighbors = [P ||
                        P = {PX, PY} <- Neighbors,
                        PX > 0, PX =< GX,
                        PY > 0, PY =< GY,
                        not maps:is_key(P, Known)],
    Cost = maps:get(Node, Tentative, infinity),
    Known1 = Known#{Node => Cost},
    Tentative0 = maps:remove(Node, Tentative),
    Tentative1 = lists:foldl(
                  fun(P, Acc) -> update(P, Cost, Acc, Costs) end,
                   Tentative0,
                   GoodNeighbors),
    case next_node(Tentative1) of
        undefined ->
            Known1;
        Next ->
            shortest_path(Next, Known1, Tentative1, Goal, Costs)
    end.

update(P, Cost, Tentative, Costs) ->
    Old = maps:get(P, Tentative, infinity),
    New = maps:get(P, Costs) + Cost,
    case New < Old of
        true ->
            Tentative#{P => New};
        _ ->
            Tentative
    end.

next_node(Tentative) ->
    L = lists:sort([{C, P} || {P, C} <- maps:to_list(Tentative)]),
    case L of
        [] ->
            undefined;
        [{_, N}|_] ->
            N
    end.


read_input(File) ->
    read_input(File, 1, #{}).

read_input(File, Y, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            Line1 = string:chomp(Line),
            Acc1 = lists:foldl(
                     fun({X, C}, Acc0) -> Acc0#{{X, Y} => C - $0} end,
                     Acc,
                     lists:zip(lists:seq(1, length(Line1)), Line1)
                    ),
            read_input(File, Y+1, Acc1);
        eof ->
            Acc
    end.
