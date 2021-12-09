#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day9.txt", [read]),
    {Map, H, W} = read_input(File),
    LowSpots = low_spots(H, W, Map),
    BasinSizes = lists:sort([length(basin(S, Map)) || S <- LowSpots]),
    {_, [X, Y, Z]} = lists:split(length(BasinSizes) - 3, BasinSizes),
    io:format("~p ~p~n", [lists:sum([1 + maps:get(S, Map) || S <- LowSpots]), X*Y*Z]).

basin(StartPt, Map) ->
    basin([StartPt], Map, []).

basin([], _Map, Basin) ->
    Basin;
basin([P = {Y, X} | T], Map, Basin) ->
    case lists:member(P, Basin) orelse maps:get(P, Map, 9) == 9 of
        true ->
            basin(T, Map, Basin);
        false ->
            basin(neighbors(Y, X) ++ T, Map, [P | Basin])
    end.


low_spots(H, W, Map) ->
    [
     {Y, X} ||
        Y <- lists:seq(0, H-1),
        X <- lists:seq(0, W-1),
        is_low_spot(Y, X, Map)
    ].

is_low_spot(Y, X, Map) ->
    H = maps:get({Y, X}, Map),
    [] == [nope || 
              {YY, XX} <- neighbors(Y, X),
              maps:get({YY, XX}, Map, infinity) =< H].

neighbors(Y, X) ->
    [{YY, XX} ||
        YY <- lists:seq(Y-1, Y+1),
        XX <- lists:seq(X-1, X+1),
        YY == Y orelse XX == X,
        YY =/= Y orelse XX =/= X].

read_input(File) ->
    {Pairs, Height, Width} = read_input(File, 0, 0, []),
    {maps:from_list(Pairs), Height, Width}.

read_input(File, N, Width, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            Line1 = string:chomp(Line),
            read_input(File, N+1, length(Line1), [{{N, I-1}, C - $0} || {I, C} <- lists:zip(lists:seq(1, length(Line1)), Line1)] ++ Acc);
        eof -> {Acc, N, Width}
    end.
