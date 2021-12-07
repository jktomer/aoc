#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day7.txt", [read]),
    Crabs = read_input(File),
    Targets = lists:seq(hd(Crabs), lists:last(Crabs)),
    Best1 = lists:min([lists:sum([abs(Pos - Target) || Pos <- Crabs]) || Target <- Targets]),
    Best2 = lists:min([lists:sum([(abs(Pos - Target)*(abs(Pos - Target) + 1)) div 2 || Pos <- Crabs]) || Target <- Targets]),
    io:format("~B ~B~n", [Best1, Best2]).

read_input(File) ->
    {ok, Line} = file:read_line(File),
    lists:sort([list_to_integer(N) || N <- string:split(string:chomp(Line), ",", all)]).
