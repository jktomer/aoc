#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day11.txt", [read]),
    Map = read_input(File),
    {_Map1, Flashes} = lists:foldl(fun step/2, {Map, 0}, lists:seq(1, 100)),
    SyncStep = find_sync_step(Map),
    io:format("~p ~p~n", [Flashes, SyncStep]).

find_sync_step(Map) ->
    find_sync_step(1, Map).

find_sync_step(N, Map) ->
    case step(N, {Map, 0}) of
        {_, 100} ->
            N;
        {Map1, _} ->
            find_sync_step(N+1, Map1)
    end.

step(_, {Map, FlashesAcc}) ->
    Map1 = [{P, E+1} || {P, E} <- Map],
    {Map2, Flashes} = find_flashes(Map1, sets:new()),
    Map3 = clear_flashers(Map2),
    {Map3, FlashesAcc + Flashes}.

clear_flashers(Map) ->
    [{P, if E =< 9 -> E; true -> 0 end} || {P, E} <- Map].

find_flashes(Map, Flashed) ->
    case [P || {P, E} <- Map, E > 9, not sets:is_element(P, Flashed)] of
        [P|_] ->
            find_flashes(bump_neighbors(P, Map), sets:add_element(P, Flashed));
        [] ->
            {Map, sets:size(Flashed)}
    end.

bump_neighbors(P, Map) ->
    {Neighbors, Others} = lists:partition(fun({Q, _}) ->neighbor(P, Q) end, Map),
    [{Q, E+1} || {Q, E} <- Neighbors] ++ Others.

neighbor({Y, X}, {YY, XX}) ->
    DY = (YY-Y),
    DX = (XX-X),
    Dist = DY*DY + DX*DX,
    Dist == 1 orelse Dist == 2.

read_input(File) ->
    read_input(File, 0, []).

read_input(File, N, Acc) ->
    case file:read_line(File) of
        {ok, Line} -> 
            Line1 = string:chomp(Line),
            read_input(File, N+1, [{{N, I-1}, C - $0} || {I, C} <- lists:zip(lists:seq(1, length(Line1)), Line1)] ++ Acc);
        eof -> Acc
    end.
