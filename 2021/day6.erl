#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day6.txt", [read]),
    Fish = read_state(File),
    AgeCount = lists:foldl(fun(Age, Acc) -> maps:update_with(Age, fun(N)-> N+1 end, 1, Acc) end, #{}, Fish),
    AgeCount1 = lists:foldl(fun step/2, maps:to_list(AgeCount), lists:seq(1, 80)),
    AgeCount2 = lists:foldl(fun step/2, AgeCount1, lists:seq(81, 256)),
    io:format("~B ~B~n", [lists:sum([V || {_, V} <- AgeCount1]), lists:sum([V || {_, V} <- AgeCount2])]).

step(_, AgeCount) ->
    SixDay = proplists:get_value(0, AgeCount, 0) + proplists:get_value(7, AgeCount, 0),
    S = [ {6, SixDay} | [{case A of 0 -> 8; _ -> A - 1 end, C} || {A, C} <- AgeCount, A =/= 7 ]],
    S.

read_state(File) ->
    {ok, Line} = file:read_line(File),
    [list_to_integer(N) || N <- string:split(string:chomp(Line), ",", all)].
