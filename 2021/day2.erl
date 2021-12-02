#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).

main(_) ->
    {ok, File} = file:open("day2.txt", [read]),
    Steps = [parse_step(L) || L <- read_lines(File)],
    {Horiz1, Depth1} = lists:foldl(fun handle_step1/2, {0, 0}, Steps),
    {Horiz2, Depth2, _Aim} = lists:foldl(fun handle_step2/2, {0, 0, 0}, Steps),
    io:format("~B ~B~n", [Horiz1 * Depth1, Horiz2 * Depth2]).

parse_step(Line) ->
    [RawDir, RawMag] = string:split(Line, " "),
    Dir = list_to_atom(RawDir),
    Mag = list_to_integer(RawMag),
    {Dir, Mag}.

handle_step1({forward, Mag}, {Horiz, Depth}) ->
    {Horiz + Mag, Depth};
handle_step1({up, Mag}, {Horiz, Depth}) ->
    {Horiz, Depth - Mag};
handle_step1({down, Mag}, {Horiz, Depth}) ->
    {Horiz, Depth + Mag}.

handle_step2({forward, Mag}, {Horiz, Depth, Aim}) ->
    {Horiz + Mag, Depth + Mag * Aim, Aim};
handle_step2({up, Mag}, {Horiz, Depth, Aim}) ->
    {Horiz, Depth, Aim - Mag};
handle_step2({down, Mag}, {Horiz, Depth, Aim}) ->
    {Horiz, Depth, Aim + Mag}.

read_lines(File) ->
    lists:reverse(read_lines(File, [])).

read_lines(File, Acc) ->
    case file:read_line(File) of
        eof -> Acc;          
        {ok, Line} -> read_lines(File, [string:trim(Line) | Acc])
    end.
